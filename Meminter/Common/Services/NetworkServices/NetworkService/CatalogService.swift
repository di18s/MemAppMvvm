//
//  CatalogService.swift
//  Meminter
//
//  Created by Холмогоров Дмитрий on 30.11.2020.
//

import Foundation
import Combine

protocol CatalogServiceInput: class {
    func catalog(_ api: APIMethod) -> AnyPublisher<[MemModel], Error>
}

final class CatalogService: BaseNetworkService, CatalogServiceInput {
    func catalog(_ api: APIMethod) -> AnyPublisher<[MemModel], Error> {
        let request = URLRequest(url: api.url)
        return self.getPublisher(request)
    }
}
