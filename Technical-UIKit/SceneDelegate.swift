//
//  SceneDelegate.swift
//  Technical-UIKit
//
//  Created by José María Jiménez on 2/2/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let navigationController = UINavigationController()
        let dependencies = AppDependencies(navigationController: navigationController)
        let vc = dependencies.getInitialVC()
        navigationController.viewControllers = [vc]
        window?.rootViewController = navigationController

        window?.makeKeyAndVisible()
    }
}

