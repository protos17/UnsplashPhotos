//
//  DetailViewController.swift
//  UnsplashPhotoCollection
//
//  Created by Данил Чапаров on 23.06.2022.
//

import UIKit
import Kingfisher

final class DetailViewController: UIViewController {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.white
        imageView.image = UIImage(systemName: "photo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var downloadCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
    }
    
    private func addViews() {
        view.backgroundColor = .black
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        stackView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: stackView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor)
        ])
        
        stackView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        stackView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        stackView.addSubview(locationLabel)
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            locationLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        stackView.addSubview(downloadCountLabel)
        NSLayoutConstraint.activate([
            downloadCountLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor),
            downloadCountLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            downloadCountLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            downloadCountLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(with model: PhotoModel) {
        print(model)
        imageView.kf.indicatorType = .activity
        if let imageString = model.urls.small {
            let imageURL = URL(string: imageString)
            imageView.kf.setImage(with: imageURL)
        }
        DispatchQueue.main.async {
            self.nameLabel.text = "Author name: \(model.user.name ?? "unknown")"
            self.dateLabel.text = "Photo created: \(model.createdAt ?? "unknown")"
            self.locationLabel.text = "Author location: \(model.user.location ?? "unknown")"
            self.downloadCountLabel.text = "Photo downloads: \(model.downloads ?? 0)"
        }
    }
}
