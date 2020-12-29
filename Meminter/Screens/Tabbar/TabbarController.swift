//
//  TabbarController.swift
//  Meminter
//
//  Created by Дмитрий Х on 11.11.2020.
//

import UIKit

final class TabbarController: UITabBarController {
	private var controllersFactory: TabbarControllersFactoryType
    
    init(controllersFactory: TabbarControllersFactoryType) {
		self.controllersFactory = controllersFactory
        
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .fullScreen
        self.tabBar.barTintColor = .white
        self.tabBar.tintColor = .black

		self.setupViewControllers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	private func setupViewControllers() {
		let catalogVC = self.controllersFactory.makeCatalogController()
		let memsCreator = self.controllersFactory.makeMemsCreatorCoordinator()
		let swipeMemsVC = self.controllersFactory.makeSwipeMemsController()

		var controllers = [UIViewController]()

		controllers.append(swipeMemsVC)
		controllers.append(memsCreator)
		controllers.append(catalogVC)

		viewControllers = controllers

		memsCreator.onEndCreateMemsFlow = { [weak self, weak catalogVC] in
			guard let catalog = catalogVC else { return }
			self?.selectedIndex = self?.viewControllers?.firstIndex(of: catalog) ?? 0
		}
	}
}
