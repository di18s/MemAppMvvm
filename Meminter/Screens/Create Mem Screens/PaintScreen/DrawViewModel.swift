//
//  DrawViewModel.swift
//  Meminter
//
//  Created by Холмогоров Дмитрий on 05.11.2020.
//

import Foundation

protocol DrawViewModelInput: class {
    var userDefaultsProvider: UserDefaultsProviderInput { get }
    var onError: ((String) -> Void)? { get set }
	var onSuccess: (() -> Void)? { get set }

    func postImage(_ imageData: Data?)
}

final class DrawViewModel: DrawViewModelInput {
	let userDefaultsProvider: UserDefaultsProviderInput
	var onError: ((String) -> Void)?
	var onSuccess: (() -> Void)?
	
    private let networkService: DrawMemServiceInput
    
    init(networkService: DrawMemServiceInput, userDefaultsProvider: UserDefaultsProviderInput) {
        self.networkService = networkService
        self.userDefaultsProvider = userDefaultsProvider
    }
    
	func postImage(_ imageData: Data?) {
		self.networkService.postImage(imageData: imageData, by: .pic) { [weak self] result in
			switch result {
			case .failure(let error):
			self?.onError?(error)
			case .success:
				self?.onSuccess?()
			}
		}
	}
}
