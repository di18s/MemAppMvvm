//
//  TabbarController.swift
//  Meminter
//
//  Created by Дмитрий Х on 11.11.2020.
//

import UIKit

final class TabbarController: UITabBarController {
    private var viewModel: TabbarViewModelInput
    
    init(viewModel: TabbarViewModelInput) {
        self.viewModel = viewModel
        
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
        self.viewControllers = self.viewModel.createViewControllers()
        self.viewModel.onMemsCreationFlowEnded = { [weak self] controllerIndex in
            self?.selectedIndex = controllerIndex
        }
    }
}
