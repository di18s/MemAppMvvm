//
//  DrawViewModel.swift
//  Meminter
//
//  Created by Холмогоров Дмитрий on 05.11.2020.
//

import Foundation

protocol DrawViewModelInput: class {
    var userDefaultsProvider: UserDefaultsProviderInput { get }
    var onError: ((String?) -> Void)? { get set }
    func postImage(_ imageData: Data?)
}

final class DrawViewModel: DrawViewModelInput {
    private let networkService: NetworkServiceInput
    let userDefaultsProvider: UserDefaultsProviderInput
    
    var onError: ((String?) -> Void)?
    
    init(networkService: NetworkServiceInput, userDefaultsProvider: UserDefaultsProviderInput) {
        self.networkService = networkService
        self.userDefaultsProvider = userDefaultsProvider
    }
    
    func postImage(_ imageData: Data?) {
        self.networkService.post(imageData: imageData, by: .pic) { [weak self] error in
            self?.onError?(error)
        }
    }
}
