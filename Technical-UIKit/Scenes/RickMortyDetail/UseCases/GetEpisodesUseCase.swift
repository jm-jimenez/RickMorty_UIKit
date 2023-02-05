//
//  GetEpisodesUseCase.swift
//  Technical-UIKit
//
//  Created by José María Jiménez on 4/2/23.
//

final class GetEpisodesUseCase: UseCase<GetEpisodesUseCaseInput, GetEpisodesUseCaseOkOutput, Error> {

    private let networkClient: NetworkClientProtocol

    init(resolver: AppDependenciesResolver) {
        networkClient = resolver.resolve()
    }

    override func execute(requestValues: GetEpisodesUseCaseInput) -> UseCaseResponse<GetEpisodesUseCaseOkOutput, Error> {
        let url = "https://rickandmortyapi.com/api/episode/" + requestValues.episodes.joined(separator: ",")
        let request = NetworkRequest(url: url)
        switch requestValues.episodes.count {
        case 1: return handleSingleEpisodeRequest(request)
        default: return handleMultipleEpisodesRequest(request)
        }
    }
}

private extension GetEpisodesUseCase {
    func handleMultipleEpisodesRequest(_ request: NetworkRequest) -> UseCaseResponse<GetEpisodesUseCaseOkOutput, Error> {
        let result: NetworkResponse<[GetEpisodesResponse.Episode], Error> = networkClient.request(request)
        switch result {
        case .success(let output):
            return .ok(GetEpisodesUseCaseOkOutput(episodes: output))
        case .error(let error):
            return .error(error)
        }
    }

    func handleSingleEpisodeRequest(_ request: NetworkRequest) -> UseCaseResponse<GetEpisodesUseCaseOkOutput, Error> {
        let result: NetworkResponse<GetEpisodesResponse.Episode, Error> = networkClient.request(request)
        switch result {
        case .success(let output):
            return .ok(GetEpisodesUseCaseOkOutput(episodes: [output]))
        case .error(let error):
            return .error(error)
        }
    }
}

struct GetEpisodesUseCaseInput {
    let episodes: [String]
}

struct GetEpisodesUseCaseOkOutput {
    let episodes: [GetEpisodesResponse.Episode]
}
