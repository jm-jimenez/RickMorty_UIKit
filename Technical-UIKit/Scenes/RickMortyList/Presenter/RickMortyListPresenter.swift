//
//  RickMortyListPresenter.swift
//  Technical-UIKit
//
//  Created by José María Jiménez on 3/2/23.
//

import Foundation

protocol RickMortyListPresenterProtocol {
    var view: RickMortyListView? { get set }
    var isLoading: Bool { get }
    func viewDidLoad()
    func didSelectCharacter(with viewModel: RickMortyListRowViewModel)
    func loadMoreCharacters()
    func setIsFilteringTo(_ isFiltering: Bool)
    func filterCharacters(with: String?)
}

final class RickMortyListPresenter {
    weak var view: RickMortyListView?
    private let resolver: AppDependenciesResolver
    private var nextPage: String?
    private var characters = [GetAllCharactersResponse.Character]()
    var isLoading = false
    private var isFiltering = false

    init(resolver: AppDependenciesResolver) {
        self.resolver = resolver
    }
}

extension RickMortyListPresenter: RickMortyListPresenterProtocol {
    func viewDidLoad() {
        loadCharacters(input: GetCharacterListUseCaseInput(page: nil))
    }

    func didSelectCharacter(with viewModel: RickMortyListRowViewModel) {
        guard let character = characters.first(where: { $0.id == viewModel.id }) else { return }
        coordinator.goToDetailViewController(character: character)
    }

    func loadMoreCharacters() {
        guard !isLoading else { return }
        loadCharacters(input: GetCharacterListUseCaseInput(page: nextPage))
    }

    func filterCharacters(with text: String?) {
        guard let text else { return }
        loadCharacters(input: GetCharacterListUseCaseInput(type: .filter(name: text)))
    }

    func setIsFilteringTo(_ isFiltering: Bool) {
        self.isFiltering = isFiltering
    }
}

private extension RickMortyListPresenter {
    var getCharacterListUseCase: GetCharacterListsUseCase {
        resolver.resolve()
    }

    var coordinator: AppCoordinatorProtocol {
        resolver.resolve()
    }

    func loadCharacters(input: GetCharacterListUseCaseInput) {
        view?.setLoading(true)
        isLoading = true
        Scenario(useCase: getCharacterListUseCase, input: input)
            .execute()
            .onSuccess { output in
                self.isLoading = false
                self.characters = self.characters + output.characters.filter { current in
                    !self.characters.contains { coming in
                        current.id == coming.id
                    }}
                self.nextPage = output.nextPage
                let rowsViewModel = self.characters.map {
                    RickMortyListRowViewModel(id: $0.id,
                                              url: $0.image,
                                              name: $0.name,
                                              species: $0.species,
                                              gender: $0.gender,
                                              episodes: $0.episode.count
                    )
                }
                self.view?.setLoading(false)
                self.view?.setRowsViewModel(rowsViewModel)
            }
            .onError { error in
                self.isLoading = false
                self.view?.setLoading(false)
                self.view?.setError()
            }
    }
}
