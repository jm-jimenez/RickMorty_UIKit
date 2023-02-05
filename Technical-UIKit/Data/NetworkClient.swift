//
//  NetworkClient.swift
//  Technical-UIKit
//
//  Created by José María Jiménez on 3/2/23.
//

import Foundation

protocol NetworkClientProtocol {
    func request<Output: Decodable>(_ request: NetworkRequest) -> NetworkResponse<Output, Error>
}

struct NetworkClient: NetworkClientProtocol {

    private let client = URLSession.shared

    func request<Output: Decodable>(_ request: NetworkRequest) -> NetworkResponse<Output, Error> {
        guard let request = buildRequest(from: request) else { return .error(error: NetworkError.invalidRequest) }
        var response: NetworkResponse<Output, Error> = .error(error: NetworkError.unknown)
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        client.dataTask(with: request) { data, _, _ in
            defer {
                dispatchGroup.leave()
            }
            guard let data else {
                response = .error(error: NetworkError.koResponse)
                return
            }
            do {
                let result = try JSONDecoder().decode(Output.self, from: data)
                response = .success(output: result)
            } catch {
                response = .error(error: NetworkError.parsing)
            }
        }.resume()
        dispatchGroup.wait()
        return response
    }
}

private extension NetworkClient {
    func buildRequest(from: NetworkRequest) -> URLRequest? {
        guard let url = URL(string: from.url) else { return nil }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)
        request.httpMethod = from.method.rawValue
        return request
    }
}

struct NetworkRequest {
    let url: String
    let method: HTTPMethod = .get

    enum HTTPMethod: String {
        case post = "POST"
        case get = "GET"
    }
}

enum NetworkError: Error {
    case unknown
    case invalidRequest
    case koResponse
    case parsing
}
