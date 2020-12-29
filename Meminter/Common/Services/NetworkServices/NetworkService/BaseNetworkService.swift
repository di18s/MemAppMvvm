//
//  NetworkManager.swift
//  SimpleDrawing
//
//  Created by Дмитрий on 09/09/2019.
//  Copyright © 2019 Дмитрий. All rights reserved.
//

import Foundation
import Combine

enum Result {
	case failure(error: String)
	case success
}

protocol NetworkServiceInput: LoggableInput {
	func getPublisher<T: Codable>(_ request: URLRequest) -> AnyPublisher<T, Error>
	func getPublisher(_ request: URLRequest) -> AnyPublisher<Data, Error>
	func postPublisher(_ request: URLRequest) -> AnyPublisher<Any, URLError>
	func post(_ request: URLRequest, completion: @escaping (Result) -> Void) -> Void
}

class BaseNetworkService: NetworkServiceInput {
    private let urlSession: URLSession

    init(urlSession: URLSession = .init(configuration: .default)) {
        self.urlSession = urlSession
    }

	func getPublisher<T: Codable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
		return self.urlSession.dataTaskPublisher(for: request)
			.compactMap { [weak self] (data, response) -> Data in
				self?.log(response)
				return data
			}
			.decode(type: T.self, decoder: JSONDecoder())
			.eraseToAnyPublisher()
	}

	func getPublisher(_ request: URLRequest) -> AnyPublisher<Data, URLError> {
		return self.urlSession.dataTaskPublisher(for: request)
			.compactMap { [weak self] (data, response) -> Data in
				self?.log(response)
				return data
			}
			.eraseToAnyPublisher()
	}
    
	func post(_ request: URLRequest, completion: @escaping (Result) -> Void) -> Void {
        self.urlSession.uploadTask(with: request, from: request.httpBody) { _, response, error in
			self.log(response)
			if let error = error {
				completion(.failure(error: error.localizedDescription))
			} else {
				completion(.success)
			}
        }.resume()
    }

	func postPublisher(_ request: URLRequest) -> AnyPublisher<Any, URLError> {
		return self.urlSession.dataTaskPublisher(for: request)
			.map { [weak self] (data, response) -> Any in
				self?.log(response)
				return data
			}
			.eraseToAnyPublisher()
	}
}
