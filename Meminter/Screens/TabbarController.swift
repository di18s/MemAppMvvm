//
//  TabbarController.swift
//  Meminter
//
//  Created by Дмитрий Х on 11.11.2020.
//

import UIKit

class TabbarController: UITabBarController {

    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
        self.tabBar.barTintColor = .white
        self.tabBar.tintColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = self.createViewControllers()
    }
    
    private func createViewControllers() -> [UIViewController] {
        var controllers = [UIViewController]()
        // ***
        let drawFlowNavController = CreateMemsCoordinator()
        drawFlowNavController.start()
        drawFlowNavController.tabBarItem = UITabBarItem(title: "Создать", image: #imageLiteral(resourceName: "hair-dye (1)"), selectedImage: #imageLiteral(resourceName: "hair-dye"))
        // ***
        let catalogVM = CatalogViewModel(networkService: NetworkServicesAssembly.networkService())
        let catalogVC = CatalogViewController(catalogViewModel: catalogVM)
        let catalogNVC = UINavigationController(rootViewController: catalogVC)
        catalogNVC.navigationBar.isHidden = true
        catalogNVC.tabBarItem = UITabBarItem(title: "Каталог", image: #imageLiteral(resourceName: "app"), selectedImage: #imageLiteral(resourceName: "app (1)"))
        // ***
        let swipeVM = SwipeReviewViewModel(networkService: NetworkServicesAssembly.networkService())
        let swipeVC = SwipeReviewViewController(viewModel: swipeVM)
        swipeVC.tabBarItem = UITabBarItem(title: "Лайкать", image: #imageLiteral(resourceName: "smile"), selectedImage: #imageLiteral(resourceName: "smileSelection"))
        
        drawFlowNavController.onEndCreateMemsFlow = { [weak self, weak catalogNVC] in
            guard let strongSelf = self, let catalog = catalogNVC else { return }
            strongSelf.selectedIndex = strongSelf.viewControllers?.firstIndex(of: catalog) ?? 0
        }
        
        controllers.append(swipeVC)
        controllers.append(drawFlowNavController)
        controllers.append(catalogNVC)
        
        return controllers
    }
}
