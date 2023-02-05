//
//  InfoRowCell.swift
//  Technical-UIKit
//
//  Created by José María Jiménez on 4/2/23.
//

import UIKit

final class InfoRowCell: UITableViewCell {

    @IBOutlet private weak var keyLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    func setupViewModel(_ viewModel: InfoRowViewModel) {
        keyLabel.text = viewModel.key
        valueLabel.text = viewModel.value
    }
}

private extension InfoRowCell {
    func setupView() {
        keyLabel.font = .preferredFont(forTextStyle: .body)
        valueLabel.font = .preferredFont(forTextStyle: .body)
        valueLabel.textColor = .secondaryLabel
    }
}
