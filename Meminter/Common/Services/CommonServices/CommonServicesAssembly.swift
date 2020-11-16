//
//  CommonServicesAssembly.swift
//  Meminter
//
//  Created by Холмогоров Дмитрий on 05.11.2020.
//

import Foundation

enum CommonServicesAssembly {
    private static weak var userDefaultsProviderContainer: UserDefaultsProviderInput?
    
    static func userDefaultsProvider() -> UserDefaultsProviderInput {
        if let userDefaultsProvider = self.userDefaultsProviderContainer {
            return userDefaultsProvider
        } else {
            let userDefaultsProvider = UserDefaultsProvider()
            self.userDefaultsProviderContainer = userDefaultsProvider
            return userDefaultsProvider
        }
    }

    private static weak var urlRequestBuilderContainer: URLRequestBuilderType?
    
    static func urlRequestBuilder() -> URLRequestBuilderType {
        if let urlRequestBuilder = self.urlRequestBuilderContainer {
            return urlRequestBuilder
        } else {
            let urlRequestBuilder = URLRequestBuilder()
            self.urlRequestBuilderContainer = urlRequestBuilder
            return urlRequestBuilder
        }
    }
}
