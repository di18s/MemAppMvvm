//
//  SwipeReviewService.swift
//  Meminter
//
//  Created by Холмогоров Дмитрий on 30.11.2020.
//

import Foundation
import Combine

protocol SwipeReviewServiceInput: class {
	func swipeReview(_ api: APIMethod) -> AnyPublisher<[MemModel], Error>
	func setRating(_ api: APIMethod) -> AnyPublisher<Data, URLError>
}

final class SwipeReviewService: BaseNetworkService, SwipeReviewServiceInput {
	func swipeReview(_ api: APIMethod) -> AnyPublisher<[MemModel], Error> {
		let request = URLRequest(url: api.url)
		return self.getPublisher(request)
	}

	func setRating(_ api: APIMethod) -> AnyPublisher<Data, URLError> {
		let request = URLRequest(url: api.url)
		return self.getPublisher(request)
	}
}
