//
//  GetEpisodesResponse.swift
//  Technical-UIKit
//
//  Created by José María Jiménez on 4/2/23.
//

struct GetEpisodesResponse {
    struct Episode: Decodable {
        let id: Int
        let name: String
        let airDate: String
        let episode: String

        enum CodingKeys: String, CodingKey {
            case id, name, episode
            case airDate = "air_date"
        }
    }
}
