//
//  MainCollectionCell.swift
//  UnsplashPhotoCollection
//
//  Created by Данил Чапаров on 22.06.2022.
//

import UIKit
import RxSwift
import Kingfisher

final class MainCollectionCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.white
        imageView.image = UIImage(systemName: "photo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func configureCell(with model: PhotoModel) {
        imageView.kf.indicatorType = .activity
        if let imageString = model.urls.small {
            let imageURL = URL(string: imageString)
            imageView.kf.setImage(with: imageURL)
        }
    }
}
