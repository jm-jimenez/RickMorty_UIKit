//
//  Sections.swift
//  Technical-UIKit
//
//  Created by José María Jiménez on 4/2/23.
//

import UIKit

extension RickMortyDetailViewController {
    enum Sections {
        case info(rowViewModels: [InfoRowViewModel])
        case episodes(rowViewModels: [EpisodeRowViewModel])

        var numberOfRowsInSection: Int {
            switch self {
            case .info(let viewModels): return viewModels.count
            case .episodes(let viewModels): return viewModels.count
            }
        }

        var title: String {
            switch self {
            case .info:
                return "Character info"
            case .episodes:
                return "Appears on"
            }
        }

        func cellForRowAt(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
            switch self {
            case .info(let viewModels):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfoRowReuse", for: indexPath) as? InfoRowCell else { return UITableViewCell() }
                cell.setupViewModel(viewModels[indexPath.item])
                return cell
            case .episodes(let viewModels):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeRowReuse", for: indexPath) as? EpisodeRowCell else { return UITableViewCell() }
                cell.setupViewModel(viewModels[indexPath.item])
                return cell
            }
        }
    }
}
