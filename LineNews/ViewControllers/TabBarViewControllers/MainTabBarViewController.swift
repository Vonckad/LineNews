//
//  MainTabBarViewController.swift
//  LineNews
//
//  Created by Vlad Ralovich on 18.02.2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
//    private var newsVC = UINavigationController(rootViewController: NewsTableViewController())
//    private var
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = Theme.tabBarBackgroundColor
        
        setViewControllers([createNavController(for: NewsTableViewController(),
                                                title: "Новости", image: UIImage(named: "news_image")),
                           createNavController(for: MapViewController(),
                                               title: "Карта", image: UIImage(named: "map_image")),
                           createNavController(for: FavouritesViewController(),
                                               title: "Избранное", image: UIImage(named: "favourites_image")),
                           createNavController(for: ProfileViewController(),
                                               title: "Профиль", image: UIImage(named: "profile_image"))], animated: false)
    }

    fileprivate func createNavController(for rootViewController: UIViewController,
                                         title: String,
                                         image: UIImage?) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navController
    }
    
}
