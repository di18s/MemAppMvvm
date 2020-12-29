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
		}
		let networkService = BaseNetworkService()
		self.networkServiceContainer = networkService
		return networkService
	}

	private static weak var catalogServiceContainer: CatalogServiceInput?

	static func catalogService() -> CatalogServiceInput {
		if let catalogService = self.catalogServiceContainer {
			return catalogService
		}
		let catalogService = CatalogService()
		self.catalogServiceContainer = catalogService
		return catalogService
	}

	private static weak var swipeReviewServiceContainer: SwipeReviewServiceInput?

	static func swipeReviewService() -> SwipeReviewServiceInput {
		if let swipeReviewService = self.swipeReviewServiceContainer {
			return swipeReviewService
		}
		let swipeReviewService = SwipeReviewService()
		self.swipeReviewServiceContainer = swipeReviewService
		return swipeReviewService
	}

	private static weak var buildMemServiceContainer: BuildMemServiceInput?

	static func buildMemService() -> BuildMemServiceInput {
		if let buildMemService = self.buildMemServiceContainer {
			return buildMemService
		}
		let buildMemService = BuildMemService(requestBuilder: CommonServicesAssembly.urlRequestBuilder())
		self.buildMemServiceContainer = buildMemService
		return buildMemService

	}

	private static weak var writeTextServiceContainer: WriteTextServiceInput?

	static func writeTextService() -> WriteTextServiceInput {
		if let writeTextService = self.writeTextServiceContainer {
			return writeTextService
		}
		let writeTextService = WriteTextService()
		self.writeTextServiceContainer = writeTextService
		return writeTextService
	}

	private static weak var drawMemServiceContainer: DrawMemServiceInput?

	static func drawMemService() -> DrawMemServiceInput {
		if let drawMemService = self.drawMemServiceContainer {
			return drawMemService
		}
		let drawMemService = DrawMemService(requestBuilder: CommonServicesAssembly.urlRequestBuilder())
		self.drawMemServiceContainer = drawMemService
		return drawMemService
	}
}
