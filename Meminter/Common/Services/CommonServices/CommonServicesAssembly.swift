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
		}
		let userDefaultsProvider = UserDefaultsProvider()
		self.userDefaultsProviderContainer = userDefaultsProvider
		return userDefaultsProvider
	}

    private static weak var urlRequestBuilderContainer: URLRequestBuilderType?

	static func urlRequestBuilder() -> URLRequestBuilderType {
		if let urlRequestBuilder = self.urlRequestBuilderContainer {
			return urlRequestBuilder
		}
		let urlRequestBuilder = URLRequestBuilder()
		self.urlRequestBuilderContainer = urlRequestBuilder
		return urlRequestBuilder
    }

	private static weak var tabbarControllersFactoryContainer: TabbarControllersFactoryType?

	static func tabbarControllersFactory() -> TabbarControllersFactoryType {
		if let tabbarControllersFactory = self.tabbarControllersFactoryContainer {
			return tabbarControllersFactory
		}
		let tabbarControllersFactory = TabbarControllersFactory()
		self.tabbarControllersFactoryContainer = tabbarControllersFactory
		return tabbarControllersFactory
	}
}
