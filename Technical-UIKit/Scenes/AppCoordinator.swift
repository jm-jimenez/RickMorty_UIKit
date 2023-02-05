//
//  AppCoordinator.swift
//  Technical-UIKit
//
//  Created by José María Jiménez on 3/2/23.
//

import Foundation
import UIKit

protocol AppCoordinatorProtocol {
    func getListViewController() -> RickMortyListViewController
    func goToDetailViewController(character: GetAllCharactersResponse.Character)
}

struct AppCoordinator: AppCoordinatorProtocol {
    private let resolver: AppDependenciesResolver

    init(resolver: AppDependenciesResolver) {
        self.resolver = resolver
    }

    func getListViewController() -> RickMortyListViewController {
        let presenter = RickMortyListPresenter(resolver: resolver)
        let viewController = RickMortyListViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }

    func goToDetailViewController(character: GetAllCharactersResponse.Character) {
        let presenter = RickMortyDetailPresenter(resolver: resolver)
        presenter.selectedCharacter = character
        let viewController = RickMortyDetailViewController(presenter: presenter)
        presenter.view = viewController
        let navigationController: UINavigationController = resolver.resolve()
        navigationController.pushViewController(viewController, animated: true)
    }
}
