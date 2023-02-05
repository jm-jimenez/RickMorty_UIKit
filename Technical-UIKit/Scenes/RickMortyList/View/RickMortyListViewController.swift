//
//  RickMortyListViewController.swift
//  Technical-UIKit
//
//  Created by José María Jiménez on 2/2/23.
//

import UIKit

protocol RickMortyListView: AnyObject {
    func setRowsViewModel(_ rowsViewModel: [RickMortyListRowViewModel])
    func setLoading(_ isLoading: Bool)
    func setError()
}

final class RickMortyListViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noResultsView: UIView!
    @IBOutlet private weak var noResultsLabel: UILabel!

    private let presenter: RickMortyListPresenterProtocol
    private var rowsViewModel: [RickMortyListRowViewModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var isLoading: Bool = false {
        didSet {
            tableView.reloadData()
        }
    }

    init(presenter: RickMortyListPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "RickMortyListView", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        configureTableView()
        noResultsLabel.text = "No results found in ANY galaxy out there!"
        searchBar.searchTextField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
}

extension RickMortyListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Sections(rawValue: section) else { return 0 }
        switch section {
        case .characters:
            return filteredViewModels.count
        case .loading:
            return isLoading ? 1 : 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Sections(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .characters:
            if indexPath.item == filteredViewModels.count - 1,
               tableView.contentSize.height > tableView.frame.height + tableView.contentOffset.y {
                presenter.loadMoreCharacters()
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RickMortyListRowCellReuse", for: indexPath) as? RickMortyListRowCell else { return UITableViewCell() }
            cell.setViewModel(filteredViewModels[indexPath.item])
            cell.delegate = self
            return cell
        case .loading:
            let cell = UITableViewCell()
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.startAnimating()
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(activityIndicator)
            NSLayoutConstraint.activate([
                activityIndicator.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                activityIndicator.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                activityIndicator.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor)
            ])
            return cell
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

extension RickMortyListViewController: UISearchBarDelegate {
    private var filteredViewModels: [RickMortyListRowViewModel] {
        (searchBar.text ?? "").isEmpty ? rowsViewModel : rowsViewModel.filter { $0.name.range(of: searchBar.text ?? "", options: .caseInsensitive) != nil }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        let delay: Double = searchText.isEmpty ? 0 : 1
        perform(#selector(filterCharacters), with: self, afterDelay: delay)
    }
}

private extension RickMortyListViewController {
    func setupNavigationBar() {
        self.title = "Characters"
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    func configureTableView() {
        self.tableView.register(UINib(nibName: "RickMortyListRowCell", bundle: nil), forCellReuseIdentifier: "RickMortyListRowCellReuse")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
    }

    @objc func filterCharacters() {
        presenter.setIsFilteringTo(!(searchBar.text ?? "").isEmpty)
        presenter.filterCharacters(with: searchBar.text)
        guard !noResultsView.isHidden else { return }
        noResultsView.isHidden = true
    }

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

extension RickMortyListViewController: RickMortyListView {
    func setRowsViewModel(_ rowsViewModel: [RickMortyListRowViewModel]) {
        self.rowsViewModel = rowsViewModel
    }

    func setLoading(_ isLoading: Bool) {
        self.isLoading = isLoading
    }

    func setError() {
        self.noResultsView.isHidden = false
    }
}

extension RickMortyListViewController: RickMortyListRowCellDelegate {
    func didSelectViewModel(_ viewModel: RickMortyListRowViewModel) {
        presenter.didSelectCharacter(with: viewModel)
    }
}

extension RickMortyListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.endEditing(true)
        return true
    }
}
