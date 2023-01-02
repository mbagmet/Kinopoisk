//
//  SceneDelegate.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 02.01.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let navigationController = UINavigationController()
                
        window = UIWindow(windowScene: windowScene)
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
        window?.rootViewController = navigationController
        
        coordinator = AppCoordinator(navigationController: navigationController)
        coordinator?.start()
    }
}
