//
//  GetCharacterListUseCase.swift
//  Technical-UIKit
//
//  Created by José María Jiménez on 3/2/23.
//

import Foundation

final class GetCharacterListsUseCase: UseCase<GetCharacterListUseCaseInput, GetCharacterListUseCaseOkOutput, Error> {

    private let networkClient: NetworkClientProtocol

    init(resolver: AppDependenciesResolver) {
        networkClient = resolver.resolve()
    }

    override func execute(requestValues: GetCharacterListUseCaseInput) -> UseCaseResponse<GetCharacterListUseCaseOkOutput, Error> {
        var url = requestValues.page ?? "https://rickandmortyapi.com/api/character"
        if requestValues.type.isNotDefault {
            url.append(requestValues.type.path.replacingOccurrences(of: " ", with: ""))
        }
        let request = NetworkRequest(url: url)
        let result: NetworkResponse<GetAllCharactersResponse, Error> = networkClient.request(request)
        switch result {
        case .success(let output):
            return .ok(GetCharacterListUseCaseOkOutput(nextPage: output.info.next, characters: output.results))
        case .error(let error):
            return .error(error)
        }
    }
}

struct GetCharacterListUseCaseInput {
    let page: String?
    let type: RequestType

    init(page: String? = nil, type: RequestType = .default) {
        self.page = page
        self.type = type
    }

    enum RequestType {
        case `default`
        case filter(name: String)

        var path: String {
            switch self {
            case .filter(let name):
                return "/?name=\(name)"
            default: return ""
            }
        }

        var isNotDefault: Bool {
            switch self {
            case .default: return false
            default: return true
            }
        }
    }
}

struct GetCharacterListUseCaseOkOutput {
    let nextPage: String?
    let characters: [GetAllCharactersResponse.Character]
}
