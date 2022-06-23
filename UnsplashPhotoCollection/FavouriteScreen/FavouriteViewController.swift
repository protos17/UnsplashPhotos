//
//  FavouriteViewController.swift
//  UnsplashPhotoCollection
//
//  Created by Данил Чапаров on 21.06.2022.
//

import UIKit

final class FavouriteViewController: UIViewController {
    // MARK: - Private properties
    private let cellId = "tableCellId"
    private let viewModel = FavouriteScreenViewModel()
    
    // MARK: - UI elements
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Favourite"
        titleLabel.font = .systemFont(ofSize: 24)
        return titleLabel
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavouriteTableViewCell.self, forCellReuseIdentifier: self.cellId)
        tableView.rowHeight = 100
        return tableView
    }()
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        subscribe()
    }
    
    // MARK: - Private methods
    private func addViews() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func subscribe() {
        viewModel.fetchPublisher
            .subscribe { [weak self] _ in
                self?.tableView.reloadData()
            }
            .disposed(by: viewModel.disposeBag)
    }
}

// MARK: - UITableViewDelegate
extension FavouriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        guard let savedModel = viewModel.controller?.object(at: indexPath) else {
            assertionFailure("Attempt to configure cell without a managed object")
            return
        }
        let model = viewModel.changeToPhotoModel(savedModel)
        detailVC.configure(with: model)
        self.present(detailVC, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension FavouriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = viewModel.controller?.sections else {
            assertionFailure("No sections in fetchedResultsController")
            return 0
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? FavouriteTableViewCell else {
            return FavouriteTableViewCell()
        }
        guard let photoModel = viewModel.controller?.object(at: indexPath) else {
            assertionFailure("Attempt to configure cell without a managed object")
            return FavouriteTableViewCell()
        }
        cell.configure(with: photoModel)
        return cell
    }
}
