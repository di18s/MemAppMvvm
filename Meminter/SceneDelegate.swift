//
//  SceneDelegate.swift
//  Meminter
//
//  Created by Холмогоров Дмитрий on 05.11.2020.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        self.window?.windowScene = windowScene
        self.window?.rootViewController = AppCoordinator(userDefaultsProvider: CommonServicesAssembly.userDefaultsProvider())
        self.window?.makeKeyAndVisible()
    }
}
