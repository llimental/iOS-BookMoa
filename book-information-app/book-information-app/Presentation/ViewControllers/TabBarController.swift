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

        let homeTap = HomeViewController()
        let favoriteTap = FavoriteViewController()
        homeTap.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "HomeIcon"), selectedImage: UIImage(named: "HomeIcon"))
        favoriteTap.tabBarItem = UITabBarItem(title: "즐겨찾기", image: UIImage(named: "FavoriteIcon"), selectedImage: UIImage(named: "FavoriteIcon"))
        self.viewControllers = [homeTap, favoriteTap]
    }
}

