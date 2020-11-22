//
//  TabbarViewModel.swift
//  Meminter
//
//  Created by Дмитрий Х on 22.11.2020.
//

import UIKit

protocol TabbarViewModelInput {
    typealias ControllerIndex = Int
    var onMemsCreationFlowEnded: ((ControllerIndex) -> Void)? { get set }
    func makeMemsCreatorCoordinator() -> MemsCreatorCoordinator
    func makeCatalogController() -> UIViewController
    func makeSwipeMemsController() -> UIViewController
    func createViewControllers() -> [UIViewController]
}

final class TabbarViewModel: TabbarViewModelInput {
    private var controllers: [UIViewController] = []
    var onMemsCreationFlowEnded: ((ControllerIndex) -> Void)?
    
    func makeMemsCreatorCoordinator() -> MemsCreatorCoordinator {
        let memsCreatorCoordinator = MemsCreatorCoordinator()
        memsCreatorCoordinator.start()
        memsCreatorCoordinator.tabBarItem = UITabBarItem(title: "Создать", image: #imageLiteral(resourceName: "hair-dye (1)"), selectedImage: #imageLiteral(resourceName: "hair-dye"))
        return memsCreatorCoordinator
    }
    
    func makeCatalogController() -> UIViewController {
        let catalogVM = CatalogViewModel(networkService: NetworkServicesAssembly.networkService())
        let catalogVC = CatalogViewController(catalogViewModel: catalogVM)
        let catalogNVC = UINavigationController(rootViewController: catalogVC)
        catalogNVC.navigationBar.isHidden = true
        catalogNVC.tabBarItem = UITabBarItem(title: "Каталог", image: #imageLiteral(resourceName: "app"), selectedImage: #imageLiteral(resourceName: "app (1)"))
        return catalogNVC
    }
    
    func makeSwipeMemsController() -> UIViewController {
        let swipeVM = SwipeMemReviewViewModel(networkService: NetworkServicesAssembly.networkService())
        let swipeVC = SwipeMemReviewViewController(viewModel: swipeVM)
        swipeVC.tabBarItem = UITabBarItem(title: "Оценить", image: #imageLiteral(resourceName: "smile"), selectedImage: #imageLiteral(resourceName: "smileSelection"))
        return swipeVC
    }
    
    func createViewControllers() -> [UIViewController] {
        let catalogVC = self.makeCatalogController()
        let memsCreator = self.makeMemsCreatorCoordinator()
        let swipeMemsVC = self.makeSwipeMemsController()
        
        memsCreator.onEndCreateMemsFlow = { [weak self, weak catalogVC] in
            guard let catalog = catalogVC else { return }
            self?.onMemsCreationFlowEnded?(self?.controllers.firstIndex(of: catalog) ?? 0)
        }
        
        controllers.append(swipeMemsVC)
        controllers.append(memsCreator)
        controllers.append(catalogVC)
        
        return controllers
    }
}
