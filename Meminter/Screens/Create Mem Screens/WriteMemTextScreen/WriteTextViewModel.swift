//
//  WriteTextViewModel.swift
//  Meminter
//
//  Created by Холмогоров Дмитрий on 06.11.2020.
//

import Foundation

protocol WriteTextViewModelInput: class {
    var onError: ((String?) -> Void)? { get set }
    func sendText(_ text: String)
}

final class WriteTextViewModel: WriteTextViewModelInput {
    private let networkService: NetworkServiceInput
    
    var onError: ((String?) -> Void)?
    
    init(networkService: NetworkServiceInput) {
        self.networkService = networkService
    }
    
    func sendText(_ text: String) {
        self.networkService.post(by: .title(title: text)) { [weak self] error in
            self?.onError?(error)
        }
    }
}
