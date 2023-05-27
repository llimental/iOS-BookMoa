//
//  TabBarController.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/25.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeViewController = HomeViewController()
        let favoriteViewController = FavoriteViewController()

        homeViewController.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "HomeIcon"), selectedImage: UIImage(named: "HomeIcon"))
        favoriteViewController.tabBarItem = UITabBarItem(title: "즐겨찾기", image: UIImage(named: "FavoriteIcon"), selectedImage: UIImage(named: "FavoriteIcon"))

        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = UIColor(red: 0.38, green: 0.13, blue: 0.93, alpha: 1.00)

        let navigationHome: UINavigationController = {
            let navigationHome = UINavigationController(rootViewController: homeViewController)

            navigationHome.navigationBar.topItem?.backButtonTitle = ""
            navigationHome.navigationBar.tintColor = .white
            navigationHome.navigationBar.standardAppearance = navigationBarAppearance
            navigationHome.navigationBar.scrollEdgeAppearance = navigationBarAppearance

            return navigationHome
        }()

        let navigationFavorite: UINavigationController = {
            let navigationFavorite = UINavigationController(rootViewController: favoriteViewController)

            navigationFavorite.navigationBar.topItem?.backButtonTitle = ""

            return navigationFavorite
        }()

        setViewControllers([navigationHome, navigationFavorite], animated: false)

        tabBar.barTintColor = UIColor(red: 0.38, green: 0.13, blue: 0.93, alpha: 1.00)
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .systemGray2
    }
}

