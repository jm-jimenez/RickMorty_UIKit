//
//  AppDependencies.swift
//  Technical-UIKit
//
//  Created by José María Jiménez on 2/2/23.
//

import UIKit

protocol AppDependenciesResolver {
    func resolve() -> UINavigationController
    func resolve() -> AppCoordinatorProtocol
    func resolve() -> NetworkClientProtocol
    func resolve() -> GetCharacterListsUseCase
    func resolve() -> GetEpisodesUseCase
}

extension AppDependenciesResolver {
    func resolve() -> AppCoordinatorProtocol {
        AppCoordinator(resolver: self)
    }

    func resolve() -> NetworkClientProtocol {
        NetworkClient()
    }

    func resolve() -> GetCharacterListsUseCase {
        GetCharacterListsUseCase(resolver: self)
    }

    func resolve() -> GetEpisodesUseCase {
        GetEpisodesUseCase(resolver: self)
    }
}

struct AppDependencies: AppDependenciesResolver {
    let navigationController: UINavigationController

    func resolve() -> UINavigationController { navigationController }

    func getInitialVC() -> UIViewController {
        let appCoordinator: AppCoordinatorProtocol = self.resolve()
        return appCoordinator.getListViewController()
    }
}
