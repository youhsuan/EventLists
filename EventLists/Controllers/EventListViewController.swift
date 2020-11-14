//  EventListViewController.swift
//  EventLists
//
//  Created by YOU-HSUAN YU on 2020/11/14.
//

import UIKit

class EventListViewController: UIViewController {

    let viewModel: EventsViewModel
    
    init(viewModel: EventsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Events"
        viewModel.fetchEvents()
        viewModel.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        setupView()
    }

    func setupView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: "\(EventTableViewCell.self)")
    }
}

extension EventListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(EventTableViewCell.self)", for: indexPath) as? EventTableViewCell else {
            return UITableViewCell()
        }
        let item = viewModel.events[indexPath.row]
        cell.setDisplayableItem(item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.loadMoreIfNeeded(at: indexPath.row)
    }
    
}

extension EventListViewController: EventsViewModelDelegate {
    func finishFetchingEvents() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
