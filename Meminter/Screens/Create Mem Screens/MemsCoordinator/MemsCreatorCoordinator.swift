//
//  CreateMemsNavigationController.swift
//  Meminter
//
//  Created by Холмогоров Дмитрий on 06.11.2020.
//

import UIKit

private enum DrawMemsFlow {
    case draw
    case writeText
    case buldMem
    case endCreateMemsFlow
}

private enum MemControllersId: String {
    case draw = "PaintVC"
    case writeText = "writeVC"
    case buildMem = "choiceVC"
}

final class MemsCreatorCoordinator: UINavigationController {
    private let storyBoardName = "CreateMems"
    private var rootVC: UIViewController!
    var onEndCreateMemsFlow: (() -> Void)?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
        self.navigationBar.isHidden = true
        self.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        self.rootVC = self.drawMemFlow()
        self.pushViewController(self.rootVC, animated: false)
    }
    
    func drawMemFlow() -> DrawViewController? {
        guard let vc = UIStoryboard(name: self.storyBoardName, bundle: nil).instantiateViewController(withIdentifier: MemControllersId.draw.rawValue) as? DrawViewController else { return nil }
        vc.viewModel = DrawViewModel(networkService: NetworkServicesAssembly.networkService(), userDefaultsProvider: CommonServicesAssembly.userDefaultsProvider())
        vc.onEndThisFlow = { [weak self] in
            self?.nextFlow(.writeText)
        }
        
        return vc
    }
    
    func writeMemTextFlow() -> WriteTextViewController? {
        guard let vc = UIStoryboard(name: self.storyBoardName, bundle: nil).instantiateViewController(withIdentifier: MemControllersId.writeText.rawValue) as? WriteTextViewController else { return nil }
        vc.viewModel = WriteTextViewModel(networkService: NetworkServicesAssembly.networkService())
        vc.onEndThisFlow = { [weak self] in
            self?.nextFlow(.buldMem)
        }
        return vc
    }
    
    func buildMemFlow() -> BuildMemViewController? {
        guard let vc = UIStoryboard(name: self.storyBoardName, bundle: nil).instantiateViewController(withIdentifier: MemControllersId.buildMem.rawValue) as? BuildMemViewController else { return nil }
        vc.viewModel = BuildMemViewModel(networkService: NetworkServicesAssembly.networkService(), userDefaultsProvider: CommonServicesAssembly.userDefaultsProvider())
        vc.onEndThisFlow = { [weak self] in
            self?.nextFlow(.endCreateMemsFlow)
        }
        return vc
    }
    
    private func nextFlow(_ flow: DrawMemsFlow) {
        DispatchQueue.main.async {
            switch flow {
            case .draw:
                guard let drawVC = self.drawMemFlow() else { return }
                self.pushViewController(drawVC, animated: true)
            case .writeText:
                guard let writeVC = self.writeMemTextFlow() else { return }
                self.pushViewController(writeVC, animated: true)
            case .buldMem:
                guard let buldMemVC = self.buildMemFlow() else { return }
                self.pushViewController(buldMemVC, animated: true)
            case .endCreateMemsFlow:
                self.onEndCreateMemsFlow?()
                self.setViewControllers([self.rootVC], animated: true)
            }
        }
    }
}
