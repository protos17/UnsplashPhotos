//
//  FavouriteTableViewCell.swift
//  UnsplashPhotoCollection
//
//  Created by Данил Чапаров on 22.06.2022.
//

import UIKit
import Kingfisher

final class FavouriteTableViewCell: UITableViewCell {
    // MARK: - UI elements
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.white
        imageView.image = UIImage(systemName: "photo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    func configure(with model: FavouriteModel) {
        selectionStyle = .none
        photoView.kf.indicatorType = .activity
        if let imageString = model.imageUrl {
            let imageURL = URL(string: imageString)
            photoView.kf.setImage(with: imageURL)
        }
        DispatchQueue.main.async {
            self.nameLabel.text = "Author name: \(model.userName ?? "unknown")"
        }
    }
    
    // MARK: - Private methods
    private func addViews() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        stackView.addSubview(photoView)
        NSLayoutConstraint.activate([
            photoView.widthAnchor.constraint(equalToConstant: 100),
            photoView.topAnchor.constraint(equalTo: stackView.topAnchor),
            photoView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            photoView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ])
        stackView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }
}
