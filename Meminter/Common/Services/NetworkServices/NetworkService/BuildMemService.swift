//
//  BuildMemService.swift
//  Meminter
//
//  Created by Холмогоров Дмитрий on 01.12.2020.
//

import Foundation
import Combine

protocol BuildMemServiceInput: class {
	func getTitles(_ api: APIMethod) -> AnyPublisher<[MemTitleModel], Error>
	func getImages(_ api: APIMethod) -> AnyPublisher<[MemImageModel], Error>
	func sendMem(_ api: APIMethod) -> AnyPublisher<Any, URLError>?
}

final class BuildMemService: BaseNetworkService, BuildMemServiceInput {
	private var requestBuilder: URLRequestBuilderType

	init(requestBuilder: URLRequestBuilderType) {
		self.requestBuilder = requestBuilder
	}

	func getTitles(_ api: APIMethod) -> AnyPublisher<[MemTitleModel], Error> {
		let request = URLRequest(url: api.url)
		return self.getPublisher(request)
	}

	func getImages(_ api: APIMethod) -> AnyPublisher<[MemImageModel], Error> {
		let request = URLRequest(url: api.url)
		return self.getPublisher(request)
	}

	func sendMem(_ api: APIMethod) -> AnyPublisher<Any, URLError>? {
		if let request = self.requestBuilder.makeURLRequest(url: api.url, httpMethod: .post, contentType: .applicationJson) {
			return self.postPublisher(request)
		}
		return nil
	}
}
