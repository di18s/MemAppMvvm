//
//  BuildMemViewModel.swift
//  Meminter
//
//  Created by Дмитрий Х on 11.11.2020.
//

import Foundation
import Combine

struct MemSendInfo {
    var titleId: Int?
    var picId: Int?
}

enum MemViewInfo {
    case title(_ text: String)
    case url(_ url: URL)
}

enum ReloadType {
    case titles(_ titles: [MemTitleModel])
    case pics(_ pics: [MemImageModel])
}

enum SelectionType {
    case mem(id: Int, url: URL)
    case title(id: Int, text: String)
}

protocol BuildMemViewModelInput: class {    
	var memTitles: CurrentValueSubject<[MemTitleModel]?, Never> { get }
	var memImages: CurrentValueSubject<[MemImageModel]?, Never> { get }
	var currentError: CurrentValueSubject<(error: String, retryAction: () -> Void)?, Never> { get }
	var showFunnyAlert: CurrentValueSubject<(), Never> { get }
	var showSendButtonLoader: CurrentValueSubject<Bool?, Never> { get }
	var memBuildUpdate: CurrentValueSubject<MemViewInfo?, Never> { get }
	var showSendButton: CurrentValueSubject<Bool?, Never> { get }

    func didAppear()
    func selectionDidTap(_ type: SelectionType)
    func clear()
    func reloadContent()
	func sendMem()
}

final class BuildMemViewModel: BuildMemViewModelInput {
	var memTitles: CurrentValueSubject<[MemTitleModel]?, Never> = CurrentValueSubject(nil)
	var memImages: CurrentValueSubject<[MemImageModel]?, Never> = CurrentValueSubject(nil)
	var currentError: CurrentValueSubject<(error: String, retryAction: () -> Void)?, Never> = CurrentValueSubject(nil)
	var showFunnyAlert: CurrentValueSubject<(), Never> = CurrentValueSubject(())
	var showSendButtonLoader: CurrentValueSubject<Bool?, Never> = CurrentValueSubject(nil)
	var memBuildUpdate: CurrentValueSubject<MemViewInfo?, Never> = CurrentValueSubject(nil)
	var showSendButton: CurrentValueSubject<Bool?, Never> = CurrentValueSubject(nil)

	private let buildMemService: BuildMemServiceInput
	private let userDefaultsProvider: UserDefaultsProviderInput

	private var memIsSent = false
	private var memSendInfo = MemSendInfo(titleId: nil, picId: nil)

	private var imagesRequest: AnyCancellable?
	private var titlesRequest: AnyCancellable?
	private var sendMemRequest: AnyCancellable?

    init(buildMemService: BuildMemServiceInput, userDefaultsProvider: UserDefaultsProviderInput) {
        self.buildMemService = buildMemService
        self.userDefaultsProvider = userDefaultsProvider
    }
    
    func didAppear() {
        if self.userDefaultsProvider.checkFor(key: .isFirstAppear) == true {
            self.userDefaultsProvider.save(value: false, for: .isFirstAppear)
			self.showFunnyAlert.send(())
        }
    }
    
    func selectionDidTap(_ type: SelectionType) {
        switch type {
        case let .mem(id, url):
            self.memSendInfo.picId = id
			self.memBuildUpdate.send(.url(url))
        case let .title(id, text):
			self.memBuildUpdate.send(.title(text))
            self.memSendInfo.titleId = id
        }
        self.showSendButtonIfNeeded()
    }
    
    private func showSendButtonIfNeeded() {
        guard self.memSendInfo.picId != nil, self.memSendInfo.titleId != nil else { return }
		self.showSendButton.send(true)
    }

	func getTitles(select: Int, count: Int) {
		titlesRequest = self.buildMemService.getTitles(.titles(select: select, count: count))
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: { [weak self] complValue in
				switch complValue {
				case .finished:
					self?.currentError.value = nil
				case .failure(let e):
					self?.titlesRequest = nil
					self?.currentError.value = (e.localizedDescription, { [weak self] in
						self?.getTitles(select: select, count: count)
					})
				}
			}, receiveValue: { [weak self] value in
				self?.memTitles.send(value.filter({ $0.titleName != "" }))
			})
	}

	func getImages(select: Int, count: Int) {
		imagesRequest = self.buildMemService.getImages(.pics(select: select, count: count))
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: { [weak self] complValue in
				switch complValue {
				case .finished:
					self?.currentError.value = nil
				case .failure(let e):
					self?.imagesRequest = nil
					self?.currentError.value = (e.localizedDescription, { [weak self] in
						self?.getImages(select: select, count: count)
					})
				}
			}, receiveValue: { [weak self] value in
				self?.memImages.send(value)
			})
	}
    
    func reloadContent() {
        self.getTitles(select: 20, count: 20)
        self.getImages(select: 20, count: 20)
    }
    
	func sendMem() {
		guard self.memIsSent == false,
			  let titleId = self.memSendInfo.titleId,
			  let picId = self.memSendInfo.picId else { return }
		
		self.showSendButtonLoader.send(true)
		self.memIsSent = true

		sendMemRequest = self.buildMemService.sendMem(.mem(titleId: titleId, picId: picId))?
			.compactMap({ $0 })
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: { [weak self] complValue in
				switch complValue {
				case .failure(let e):
					self?.sendMemRequest = nil
					self?.currentError.value = (e.localizedDescription, { [weak self] in
						self?.sendMem()
					})
				case .finished:
					self?.currentError.value = nil
					self?.memIsSent = false
					self?.showSendButtonLoader.send(false)
				}
			}, receiveValue: { _ in })
	}
    
    func clear() {
        self.memSendInfo.picId = nil
        self.memSendInfo.titleId = nil
    }
}
