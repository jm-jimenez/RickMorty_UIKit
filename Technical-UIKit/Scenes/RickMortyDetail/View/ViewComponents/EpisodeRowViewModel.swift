//
//  EpisodeRowViewModel.swift
//  Technical-UIKit
//
//  Created by José María Jiménez on 4/2/23.
//

import Foundation

struct EpisodeRowViewModel {
    let name: String
    let episode: String
    let airDate: String

    init(episode: GetEpisodesResponse.Episode) {
        name = episode.name
        self.episode = episode.episode
        airDate = episode.airDate
    }
}
