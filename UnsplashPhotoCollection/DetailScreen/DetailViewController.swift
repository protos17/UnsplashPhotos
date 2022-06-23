//
//  DetailViewController.swift
//  UnsplashPhotoCollection
//
//  Created by Данил Чапаров on 23.06.2022.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class DetailViewController: UIViewController {
    // MARK: - Private Properties
    private var viewModel = DetailViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI elements
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
    
    lazy var favouriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        subscribe()
    }
    
    // MARK: - Public methods
    func configure(with model: PhotoModel) {
        viewModel.modelPublisher.accept(model)
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
    
    // MARK: - Private methods
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
        
        stackView.addSubview(favouriteButton)
        NSLayoutConstraint.activate([
            favouriteButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 20),
            favouriteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -20)
        ])
    }
    
    private func subscribe() {
        favouriteButton
            .rx
            .tap
            .bind { [weak self] _ in
                self?.viewModel.saveOrDeleteModel()
            }
            .disposed(by: disposeBag)
        
        viewModel.isSavedPublisher
            .subscribe(onNext: { [weak self] isSaved in
                if isSaved {
                    self?.favouriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                } else {
                    self?.favouriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                }
            })
            .disposed(by: disposeBag)
    }
}
