//
//  ViewController.swift
//  UnsplashPhotoCollection
//
//  Created by Данил Чапаров on 21.06.2022.
//

import UIKit

final class MainTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
    }
    
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

