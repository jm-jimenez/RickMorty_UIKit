//
//  RickMortyListPresenterTests.swift
//  Technical-UIKitTests
//
//  Created by José María Jiménez on 2/2/23.
//

import XCTest
@testable import Technical_UIKit

final class RickMortyListPresenterTests: XCTestCase {

    let mockAppDependencies = MockAppDependencies()

    func test_given_viewDidLoad_models_should_be_twenty() throws {
        setMockData(for: .allCharacters)
        let presenter = RickMortyListPresenter(resolver: mockAppDependencies)
        let viewSpy = RickMortyListSpy()
        presenter.view = viewSpy
        let expectation = self.expectation(description: "waiting for response")
        viewSpy.setExpectation(expectation)

        presenter.viewDidLoad()
        waitForExpectations(timeout: 1)

        XCTAssert(viewSpy.rowsViewModel.count == 20)
    }

    func test_given_viewDidLoad_then_load_more_characters_should_be_forty() {
        setMockData(for: .allCharacters)
        let presenter = RickMortyListPresenter(resolver: mockAppDependencies)
        let viewSpy = RickMortyListSpy()
        presenter.view = viewSpy
        var expectation = self.expectation(description: "waiting for response")
        viewSpy.setExpectation(expectation)
        presenter.viewDidLoad()
        waitForExpectations(timeout: 1)

        setMockData(for: .moreCharacters)
        expectation = self.expectation(description: "waiting for response")
        viewSpy.setExpectation(expectation)
        presenter.loadMoreCharacters()
        waitForExpectations(timeout: 1)

        XCTAssert(viewSpy.rowsViewModel.count == 40)
    }

    func test_given_selected_character_coordinator_called() {
        setMockData(for: .allCharacters)
        let presenter = RickMortyListPresenter(resolver: mockAppDependencies)
        let viewSpy = RickMortyListSpy()
        presenter.view = viewSpy
        let expectation = self.expectation(description: "waiting for response")
        viewSpy.setExpectation(expectation)
        presenter.viewDidLoad()
        waitForExpectations(timeout: 1)

        presenter.didSelectCharacter(with: MockHelper.selectedCharacter)
        XCTAssert(mockAppDependencies.coordinatorSpy.goToDetailCalled)
    }
}

final class RickMortyListSpy: RickMortyListView {
    var expectations: [XCTestExpectation]! = []
    var rowsViewModel: [RickMortyListRowViewModel] = []

    func setExpectation(_ expectation: XCTestExpectation) {
        self.expectations.append(expectation)
    }

    func setRowsViewModel(_ rowsViewModel: [RickMortyListRowViewModel]) {
        self.rowsViewModel = rowsViewModel
        expectations.first?.fulfill()
        expectations.remove(at: 0)
    }

    func setLoading(_ isLoading: Bool) {

    }

    func setError() {

    }
}

private extension RickMortyListPresenterTests {
    enum MockRequestType {
        case allCharacters
        case moreCharacters

        var fileName: String {
            switch self {
            case .allCharacters: return "AllCharactersResponse"
            case .moreCharacters: return "MoreCharacters"
            }
        }
    }

    func setMockData(for type: MockRequestType) {
        let mockNetworkClient = mockAppDependencies.mockNetworkClient
        let bundle = Bundle(for: Self.self)
        var data: Data?
        let resource = bundle.path(forResource: type.fileName, ofType: "json")
        data = try? Data(contentsOf: URL(filePath: resource!))
        mockNetworkClient.setMockData(data)
    }

    enum MockHelper {
        static let selectedCharacter = RickMortyListRowViewModel(id: 1,
                                                                  url: "",
                                                                  name: "",
                                                                  species: "",
                                                                  gender: "",
                                                                  episodes: 0)
    }
}


