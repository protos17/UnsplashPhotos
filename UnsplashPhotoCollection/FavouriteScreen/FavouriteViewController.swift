//
//  FavouriteViewController.swift
//  UnsplashPhotoCollection
//
//  Created by Данил Чапаров on 21.06.2022.
//

import UIKit

final class FavouriteViewController: UIViewController {
    private let cellId = "tableCellId"
    let photoModel = PhotoModel(id: "", createdAt: "", urls: UrlModel(small: "https://images.unsplash.com/photo-1655726057022-3ac25fb84866?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwzMzk5ODN8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NTU5NzI3MjM&ixlib=rb-1.2.1&q=80&w=400"), user: User(name: "DANIL", location: ""), downloads: 0)

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
    }
    
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
}

extension FavouriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.configure(with: photoModel)
        self.present(detailVC, animated: true)
    }
}

extension FavouriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? FavouriteTableViewCell else {
           return FavouriteTableViewCell()
        }
        cell.configure(with: photoModel)
        return cell
    }
    
    
}
