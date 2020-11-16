//
//  WriteTextViewModel.swift
//  Meminter
//
//  Created by Холмогоров Дмитрий on 06.11.2020.
//

import Foundation

protocol WriteTextViewModelInput: class {
    var onError: ((String?) -> Void)? { get set }
    var onMemTextUpdate: ((WriteTextModel) -> Void)? { get set }
    func sendText(_ text: String)
    func clearText()
    func textBeginEditing()
    func textDidChange(_ text: String)
}

final class WriteTextViewModel: WriteTextViewModelInput {
    private let networkService: NetworkServiceInput
    private var isFirstClearText = true
    var onError: ((String?) -> Void)?
    var onMemTextUpdate: ((WriteTextModel) -> Void)?
    
    init(networkService: NetworkServiceInput) {
        self.networkService = networkService
    }
    
    func sendText(_ text: String) {
        self.networkService.post(by: .title(title: text)) { [weak self] error in
            self?.onError?(error)
        }
    }
    
    func clearText() {
        let writeModel = WriteTextModel(sendButtonHidden: true, charCounter: "0 / 50", memText: "")
        self.onMemTextUpdate?(writeModel)
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
        
        self.onMemTextUpdate?(writeModel)
    }
}
