//
//  RickMortyDetailPresenter.swift
//  Technical-UIKit
//
//  Created by José María Jiménez on 3/2/23.
//

import Foundation

protocol RickMortyDetailPresenterProtocol {
    var view: RickMortyDetailView? { get set }
    func viewDidLoad()
}

final class RickMortyDetailPresenter {
    weak var view: RickMortyDetailView?
    private let resolver: AppDependenciesResolver
    var selectedCharacter: GetAllCharactersResponse.Character?
    private var sections: [RickMortyDetailViewController.Sections] = []

    init(resolver: AppDependenciesResolver) {
        self.resolver = resolver
    }
}

extension RickMortyDetailPresenter: RickMortyDetailPresenterProtocol {
    func viewDidLoad() {
        guard let selectedCharacter else { return }
        view?.setHeaderViewModel(DetailHeaderViewModel(name: selectedCharacter.name, image: selectedCharacter.image))
        let rowViewModels = [
            InfoRowViewModel(key: "Species", value: selectedCharacter.species),
            InfoRowViewModel(key: "Gender", value: selectedCharacter.gender),
            InfoRowViewModel(key: "Status", value: selectedCharacter.status),
            InfoRowViewModel(key: "Location", value: selectedCharacter.location.name),
            InfoRowViewModel(key: "Origin", value: selectedCharacter.origin.name)
        ]
        sections.append(.info(rowViewModels: rowViewModels))
        view?.setSections(sections)
        let input = GetEpisodesUseCaseInput(episodes: selectedCharacter.episode.compactMap { $0.components(separatedBy: "/").last })
        Scenario(useCase: getEpisodesUseCase, input: input)
            .execute()
            .onSuccess { output in
                self.sections.append(.episodes(rowViewModels: output.episodes.compactMap(EpisodeRowViewModel.init)))
                self.view?.setSections(self.sections)
            }
            .onError { error in

            }
    }
}

private extension RickMortyDetailPresenter {
    var getEpisodesUseCase: GetEpisodesUseCase {
        resolver.resolve()
    }
}
