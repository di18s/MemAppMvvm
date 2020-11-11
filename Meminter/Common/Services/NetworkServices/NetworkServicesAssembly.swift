//
//  NetworkServicesAssembly.swift
//  Meminter
//
//  Created by Холмогоров Дмитрий on 05.11.2020.
//

import Foundation

enum NetworkServicesAssembly {
    private static weak var networkServiceContainer: NetworkServiceInput?
    
    static func networkService() -> NetworkServiceInput {
        if let networkService = self.networkServiceContainer {
            return networkService
        } else {
            let networkService = NetworkService(urlRequestBilder: CommonServicesAssembly.urlRequestBuilder())
            self.networkServiceContainer = networkService
            return networkService
        }
    }
}
