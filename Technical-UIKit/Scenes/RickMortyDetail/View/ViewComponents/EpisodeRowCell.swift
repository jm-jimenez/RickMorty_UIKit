//
//  EpisodeRowCell.swift
//  Technical-UIKit
//
//  Created by José María Jiménez on 4/2/23.
//

import UIKit

final class EpisodeRowCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var episode: UILabel!
    @IBOutlet weak var airDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    func setupViewModel(_ viewModel: EpisodeRowViewModel) {
        name.text = viewModel.name
        episode.text = viewModel.episode
        airDate.text = viewModel.airDate
    }
}

private extension EpisodeRowCell {
    func setupViews() {
        name.font = .preferredFont(forTextStyle: .headline)
        episode.font = .preferredFont(forTextStyle: .body)
        airDate.font = .preferredFont(forTextStyle: .caption1)
        airDate.textColor = .secondaryLabel
    }
}
