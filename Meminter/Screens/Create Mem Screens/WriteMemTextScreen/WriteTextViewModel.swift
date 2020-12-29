//
//  WriteTextViewModel.swift
//  Meminter
//
//  Created by Холмогоров Дмитрий on 06.11.2020.
//

import Foundation
import Combine

protocol WriteTextViewModelInput: class {
	var currentError: CurrentValueSubject<(error: String, retryAction: () -> Void)?, Never> { get }
	var memTextUpdateSubject: CurrentValueSubject<WriteTextModel?, Never> { get }

    func sendText(_ text: String)
    func clearText()
    func textBeginEditing()
    func textDidChange(_ text: String)
}

final class WriteTextViewModel: WriteTextViewModelInput {
	var onError: ((String?) -> Void)?
	var memTextUpdateSubject: CurrentValueSubject<WriteTextModel?, Never> = CurrentValueSubject(nil)
	var currentError: CurrentValueSubject<(error: String, retryAction: () -> Void)?, Never> = CurrentValueSubject(nil)

    private let networkService: WriteTextServiceInput
    private var isFirstClearText = true
	private var currentRequest: AnyCancellable?
    
    init(networkService: WriteTextServiceInput) {
        self.networkService = networkService
    }
    
    func sendText(_ text: String) {
		currentRequest = self.networkService.sendText(.title(title: text))
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: { [weak self] complValue in
				switch complValue {
				case .failure(let e):
					self?.currentRequest = nil
					self?.currentError.value = (e.localizedDescription, { [weak self] in
						self?.sendText(text)
					})
				case .finished:
					self?.currentError.value = nil
				}
			}, receiveValue: { _ in })
    }
    
    func clearText() {
        let writeModel = WriteTextModel(sendButtonHidden: true, charCounter: "0 / 50", memText: "")
		self.memTextUpdateSubject.send(writeModel)
    }
    
    func textBeginEditing() {
        guard self.isFirstClearText else { return }
        self.isFirstClearText = false
        self.clearText()
    }
    
    func textDidChange(_ text: String) {
        let charCounterText = "\(text.count) / 50"
        let sendButtonHidden = text.count < 3
        
        let writeModel = WriteTextModel(sendButtonHidden: sendButtonHidden, charCounter: charCounterText, memText: text)
		self.memTextUpdateSubject.send(writeModel)
    }
}
