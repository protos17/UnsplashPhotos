//
//  ViewController.swift
//  UnsplashPhotoCollection
//
//  Created by Данил Чапаров on 21.06.2022.
//

import UIKit

final class MainTabBarViewController: UITabBarController {
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
    }
    
    // MARK: - Private methods
    private func generateTabBar() {
        tabBar.backgroundColor = .lightGray
        viewControllers = [
            generateVC(
                viewController: MainViewController(),
                title: "Main",
                image: UIImage(systemName: "house")),
            generateVC(
                viewController: FavouriteViewController(),
                title: "Favourite",
                image: UIImage(systemName: "star")),
        ]
    }
    
    private func generateVC(
        viewController: UIViewController,
        title: String,
        image: UIImage?) -> UIViewController {
            viewController.tabBarItem.title = title
            viewController.tabBarItem.image = image
            return viewController
        }
}

