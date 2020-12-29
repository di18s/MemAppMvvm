//
//  WriteTextService.swift
//  Meminter
//
//  Created by Холмогоров Дмитрий on 21.12.2020.
//

import Foundation
import Combine

protocol WriteTextServiceInput: class {
	func sendText(_ api: APIMethod) -> AnyPublisher<Any, URLError>
}

final class WriteTextService: BaseNetworkService, WriteTextServiceInput {
	func sendText(_ api: APIMethod) -> AnyPublisher<Any, URLError> {
		let request = URLRequest(url: api.url)
		return self.postPublisher(request)
	}
}
