//
//  RickMortyListRowCell.swift
//  Technical-UIKit
//
//  Created by José María Jiménez on 3/2/23.
//

import UIKit

protocol RickMortyListRowCellDelegate: AnyObject {
    func didSelectViewModel(_ viewModel: RickMortyListRowViewModel)
}

final class RickMortyListRowCell: UITableViewCell {

    @IBOutlet private weak var characterImage: UIImageView!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var episodes: UILabel!
    @IBOutlet private weak var species: UILabel!
    @IBOutlet private weak var gender: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    weak var delegate: RickMortyListRowCellDelegate?
    private var cancelableTask: CancelableTask?
    private var viewModel: RickMortyListRowViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    override func prepareForReuse() {
        characterImage.image = nil
        activityIndicator.stopAnimating()
        cancelableTask?.cancel()
    }

    func setViewModel(_ viewModel: RickMortyListRowViewModel) {
        self.viewModel = viewModel
        activityIndicator.startAnimating()
        cancelableTask = characterImage.setRemoteImage(url: viewModel.url) { 
            self.activityIndicator.stopAnimating()
        }
        name.text = viewModel.name
        episodes.text = "Episodes: \(viewModel.episodes)"
        species.text = viewModel.species
        gender.text = viewModel.gender
    }
}

private extension RickMortyListRowCell {
    func setupViews() {
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnRow)))
        characterImage.layer.cornerRadius = characterImage.frame.width / 2
        name.font = .preferredFont(forTextStyle: .headline)
        episodes.font = .preferredFont(forTextStyle: .subheadline)
        [species, gender].forEach {
            $0?.font = .preferredFont(forTextStyle: .body)
            $0?.textColor = .secondaryLabel
        }
    }

    @objc func didTapOnRow() {
        guard let viewModel else { return }
        delegate?.didSelectViewModel(viewModel)
    }
}
