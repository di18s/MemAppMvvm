//
//  BuildMemViewModel.swift
//  Meminter
//
//  Created by Дмитрий Х on 11.11.2020.
//

import Foundation

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
    var onError: ((String?) -> Void)? { get set }
    var onReloadData: ((ReloadType) -> Void)? { get set }
    var onShowFunnyAlert: (() -> Void)? { get set }
    var onShowSendButtonLoader: ((Bool) -> Void)? { get set }
    var onMemBuildUpdate: ((MemViewInfo) -> Void)? { get set }
    var onShowSendButton: ((Bool) -> Void)? { get set }
    
    var memTitleArray: [MemTitleModel] { get set }
    var memImageArray: [MemImageModel] { get set }
    
    func didAppear()
    func sendMem()
    func getMemPics(select: Int, count: Int)
    func getMemTitles(select: Int, count: Int)
    func selectionDidTap(_ type: SelectionType)
    func clear()
    func reloadContent()
}

final class BuildMemViewModel: BuildMemViewModelInput {
    private let networkService: NetworkServiceInput
    private let userDefaultsProvider: UserDefaultsProviderInput
    
    private var memIsSent = false
    private var memSendInfo = MemSendInfo(titleId: nil, picId: nil)
        
    var memTitleArray = [MemTitleModel]() {
        didSet {
            DispatchQueue.main.async {
                self.onReloadData?(.titles(self.memTitleArray))
            }
        }
    }
    var memImageArray = [MemImageModel]() {
        didSet {
            DispatchQueue.main.async {
                self.onReloadData?(.pics(self.memImageArray))
            }
        }
    }
    var onReloadData: ((ReloadType) -> Void)?
    var onError: ((String?) -> Void)?
    var onShowFunnyAlert: (() -> Void)?
    var onShowSendButtonLoader: ((Bool) -> Void)?
    var onMemBuildUpdate: ((MemViewInfo) -> Void)?
    var onShowSendButton: ((Bool) -> Void)?
    
    init(networkService: NetworkServiceInput, userDefaultsProvider: UserDefaultsProviderInput) {
        self.networkService = networkService
        self.userDefaultsProvider = userDefaultsProvider
    }
    
    func didAppear() {
        if self.userDefaultsProvider.checkFor(key: .isFirstAppear) == true {
            self.userDefaultsProvider.saveValue(value: false, for: .isFirstAppear)
            self.onShowFunnyAlert?()
        }
    }
    
    func selectionDidTap(_ type: SelectionType) {
        switch type {
        case let .mem(id, url):
            self.memSendInfo.picId = id
            self.onMemBuildUpdate?(.url(url))
        case let .title(id, text):
            self.onMemBuildUpdate?(.title(text))
            self.memSendInfo.titleId = id
        }
        self.showSendButtonIfNeeded()
    }
    
    private func showSendButtonIfNeeded() {
        guard self.memSendInfo.picId != nil, self.memSendInfo.titleId != nil else { return }
        self.onShowSendButton?(true)
    }
    
    func getMemTitles(select: Int, count: Int) {
        self.networkService.get(.titles(select: select, count: count)) { [weak self] (titles: [MemTitleModel]?, error: String?) in
            if let error = error {
                DispatchQueue.main.async { self?.onError?(error) }
            } else if let titles = titles {
                self?.memTitleArray = titles.filter({ $0.titleName != "" })
            }
        }
    }
    
    func getMemPics(select: Int, count: Int) {
        self.networkService.get(.pics(select: select, count: count)) { [weak self] (pics: [MemImageModel]?, error: String?) in
            if let error = error {
                DispatchQueue.main.async { self?.onError?(error) }
            } else if let pics = pics {
                self?.memImageArray = pics
            }
        }
    }
    
    func reloadContent() {
        self.getMemTitles(select: 12, count: 12)
        self.getMemPics(select: 16, count: 16)
    }
    
    func sendMem() {
        guard self.memIsSent == false, let titleId = self.memSendInfo.titleId, let picId = self.memSendInfo.picId else { return }
        self.onShowSendButtonLoader?(true)
        self.memIsSent = true
        self.networkService.post(by: .mem(titleId: titleId, picId: picId)) { [weak self] error in
            self?.memIsSent = false
            DispatchQueue.main.async {
                self?.onShowSendButtonLoader?(false)
                self?.onError?(error)
            }
        }
    }
    
    func clear() {
        self.memSendInfo.picId = nil
        self.memSendInfo.titleId = nil
    }
}
