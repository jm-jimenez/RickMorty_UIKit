//
//  RickMortyDetailViewController.swift
//  Technical-UIKit
//
//  Created by José María Jiménez on 3/2/23.
//

import UIKit

protocol RickMortyDetailView: AnyObject {
    func setHeaderViewModel(_ viewModel: DetailHeaderViewModel)
    func setSections(_ sections: [RickMortyDetailViewController.Sections])
}

final class RickMortyDetailViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    private let presenter: RickMortyDetailPresenterProtocol
    private lazy var headerView = DetailHeaderView()
    private var sections: [Sections] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    init(presenter: RickMortyDetailPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "RickMortyDetailView", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        configureTableView()
    }
}

extension RickMortyDetailViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].numberOfRowsInSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        sections[indexPath.section].cellForRowAt(indexPath: indexPath, tableView: tableView)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension RickMortyDetailViewController: RickMortyDetailView {
    func setHeaderViewModel(_ viewModel: DetailHeaderViewModel) {
        headerView.setViewModel(viewModel)
    }

    func setSections(_ sections: [Sections]) {
        self.sections = sections
    }
}

private extension RickMortyDetailViewController {
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = headerView
        headerView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: tableView.widthAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        tableView.tableHeaderView?.layoutIfNeeded()
        tableView.register(UINib(nibName: "InfoRowCell", bundle: nil), forCellReuseIdentifier: "InfoRowReuse")
        tableView.register(UINib(nibName: "EpisodeRowCell", bundle: nil), forCellReuseIdentifier: "EpisodeRowReuse")
    }
}
