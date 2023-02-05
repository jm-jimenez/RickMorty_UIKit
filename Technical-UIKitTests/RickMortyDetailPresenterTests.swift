//
//  RickMortyDetailPresenterTests.swift
//  Technical-UIKitTests
//
//  Created by José María Jiménez on 5/2/23.
//

import XCTest
@testable import Technical_UIKit

final class RickMortyDetailPresenterTests: XCTestCase {
    let mockAppDependencies = MockAppDependencies()

    func test_given_viewDidLoad_episodes_must_be_20() {
        setMockData(for: .getEpisodes)
        let presenter = RickMortyDetailPresenter(resolver: mockAppDependencies)
        presenter.selectedCharacter = MockHelper.selectedCharacter
        let viewSpy = RickMortyDetailSpy()
        presenter.view = viewSpy
        let expectation = self.expectation(description: "waiting for response")
        viewSpy.setExpectation(expectation)

        presenter.viewDidLoad()
        waitForExpectations(timeout: 30)

        XCTAssert(viewSpy.isHeaderSet)
        viewSpy.sections.forEach {
            switch $0 {
            case .info: break
            case .episodes(let episodes):
                XCTAssert(episodes.count == 20)
            }
        }
    }
}


private extension RickMortyDetailPresenterTests {
    enum MockRequestType {
        case getEpisodes
        
        var fileName: String {
            switch self {
            case .getEpisodes: return "GetEpisodes"
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
        static let selectedCharacter = GetAllCharactersResponse.Character(id: 0, name: "", status: "", species: "", type: "", gender: "", origin: .init(name: "", url: ""), location: .init(name: "", url: ""), image: "", episode: ["1","2"], url: "", created: "")
    }
}


final class RickMortyDetailSpy: RickMortyDetailView {
    var isHeaderSet = false
    var sections: [RickMortyDetailViewController.Sections] = []
    var expectation: XCTestExpectation!

    func setHeaderViewModel(_ viewModel: DetailHeaderViewModel) {
        isHeaderSet = true
    }

    func setSections(_ sections: [RickMortyDetailViewController.Sections]) {
        self.sections = sections
        expectation.fulfill()
    }

    func setExpectation(_ expectation: XCTestExpectation) {
        self.expectation = expectation
    }
}
