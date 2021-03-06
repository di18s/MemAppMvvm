//
//  AppCoordinator.swift
//  Meminter
//
//  Created by Холмогоров Дмитрий on 05.11.2020.
//

import UIKit

final class AppCoordinator: UIViewController, LoadableViewInput {
	private let userDefaultsProvider: UserDefaultsProviderInput

	private lazy var introVC: IntroContainerViewController = {
		return IntroContainerViewController()
	}()

	private lazy var tabbar: TabbarController = {
		return TabbarController(controllersFactory: CommonServicesAssembly.tabbarControllersFactory())
	}()

    var activityIndicator: UIActivityIndicatorView!
    
    init(userDefaultsProvider: UserDefaultsProviderInput) {
        self.userDefaultsProvider = userDefaultsProvider
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startFlow()
    }
    
    func startFlow() {
        if self.userDefaultsProvider.checkFor(key: .firstStart) != true {
            self.userDefaultsProvider.save(value: true, for: .firstStart)
			self.present(self.introVC, animated: true, completion: nil)
        } else {
			self.present(self.tabbar, animated: true, completion: nil)
        }
    }

    private func setupUI() {
        self.view.backgroundColor = .black
        self.activityIndicator = UIActivityIndicatorView(style: .large)
        self.activityIndicator.color = .orange
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.activityIndicator)
        NSLayoutConstraint.activate([
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        self.setLoading(true)
    }
}
