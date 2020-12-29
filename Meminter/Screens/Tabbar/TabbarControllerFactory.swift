//
//  TabbarControllerFactory.swift
//  Meminter
//
//  Created by Холмогоров Дмитрий on 29.12.2020.
//

import UIKit

protocol TabbarControllersFactoryType: class {
	func makeMemsCreatorCoordinator() -> MemsCreatorCoordinator
	func makeCatalogController() -> UIViewController
	func makeSwipeMemsController() -> UIViewController
}

class TabbarControllersFactory: TabbarControllersFactoryType {
	func makeMemsCreatorCoordinator() -> MemsCreatorCoordinator {
		let memsCreatorCoordinator = MemsCreatorCoordinator()
		memsCreatorCoordinator.start()
		memsCreatorCoordinator.tabBarItem = UITabBarItem(title: "Создать", image: #imageLiteral(resourceName: "hair-dye (1)"), selectedImage: #imageLiteral(resourceName: "hair-dye"))
		return memsCreatorCoordinator
	}

	func makeCatalogController() -> UIViewController {
		let catalogVM = CatalogViewModel(catalogService: NetworkServicesAssembly.catalogService())
		let catalogVC = CatalogViewController(catalogViewModel: catalogVM)
		let catalogNVC = UINavigationController(rootViewController: catalogVC)
		catalogNVC.navigationBar.isHidden = true
		catalogNVC.tabBarItem = UITabBarItem(title: "Каталог", image: #imageLiteral(resourceName: "app"), selectedImage: #imageLiteral(resourceName: "app (1)"))
		return catalogNVC
	}

	func makeSwipeMemsController() -> UIViewController {
		let swipeVM = SwipeMemReviewViewModel(swipeReviewService: NetworkServicesAssembly.swipeReviewService())
		let swipeVC = SwipeMemReviewViewController(viewModel: swipeVM)
		swipeVC.tabBarItem = UITabBarItem(title: "Оценить", image: #imageLiteral(resourceName: "smile"), selectedImage: #imageLiteral(resourceName: "smileSelection"))
		return swipeVC
	}
}
