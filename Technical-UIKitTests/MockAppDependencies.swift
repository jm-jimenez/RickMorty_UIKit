//
//  MockAppDependencies.swift
//  Technical-UIKitTests
//
//  Created by José María Jiménez on 5/2/23.
//

@testable import Technical_UIKit
import UIKit

struct MockAppDependencies: AppDependenciesResolver {
    let mockNetworkClient = MockNetworkClient()
    let coordinatorSpy = MockAppCoordinator()

    func resolve() -> UINavigationController {
        fatalError()
    }

    func resolve() -> NetworkClientProtocol {
        mockNetworkClient
    }

    func resolve() -> AppCoordinatorProtocol {
        coordinatorSpy
    }
}

final class MockNetworkClient: NetworkClientProtocol {
    private var data: Data?

    func setMockData(_ data: Data?) {
        self.data = data
    }

    func request<Output>(_ request: NetworkRequest) -> NetworkResponse<Output, Error> where Output : Decodable {
        guard let data else { return .error(error: MockError.noData)}
        do {
            let result = try JSONDecoder().decode(Output.self, from: data)
            return .success(output: result)
        } catch {
            return .error(error: MockError.parsing)
        }
    }
}

final class MockAppCoordinator: AppCoordinatorProtocol {
    var goToDetailCalled = false
    func getListViewController() -> Technical_UIKit.RickMortyListViewController {
        fatalError()
    }

    func goToDetailViewController(character: Technical_UIKit.GetAllCharactersResponse.Character) {
        goToDetailCalled = true
    }
}

enum MockError: Error {
    case noData
    case parsing
}
