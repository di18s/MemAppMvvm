//
//  DrawMemService.swift
//  Meminter
//
//  Created by Холмогоров Дмитрий on 29.12.2020.
//

import Foundation

protocol DrawMemServiceInput: class {
    func postImage(imageData: Data?, by method: APIMethod, completion: @escaping (Result) -> Void)
}

final class DrawMemService: BaseNetworkService, DrawMemServiceInput {
	private var requestBuilder: URLRequestBuilderType

	init(requestBuilder: URLRequestBuilderType) {
		self.requestBuilder = requestBuilder
	}
	
    func postImage(imageData: Data?, by method: APIMethod, completion: @escaping (Result) -> Void) {
        guard let request = self.requestBuilder.makeURLRequestWithMultipart(data: imageData, url: method.url) else {
            return
        }
        self.post(request, completion: completion)
    }
}
