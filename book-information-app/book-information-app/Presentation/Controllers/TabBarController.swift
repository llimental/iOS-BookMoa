//
//  TabBarController.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/25.
//

import UIKit
import Lottie

final class TabBarController: UITabBarController {

    private let homeViewController = HomeViewController()
    private let favoriteViewController = FavoriteViewController()
    private let navigationBarAppearance: UINavigationBarAppearance = {
        let navigationBarAppearance = UINavigationBarAppearance()

        navigationBarAppearance.backgroundColor = UIColor(red: 0.38, green: 0.13, blue: 0.93, alpha: 1.00)
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        return navigationBarAppearance
    }()
    private let animationView: LottieAnimationView = {
        let lottieAnimationView = LottieAnimationView(name: "77792-book")

        lottieAnimationView.backgroundColor = UIColor(red: 0.38, green: 0.13, blue: 0.93, alpha: 1.00).withAlphaComponent(1.0)

        return lottieAnimationView
    }()

    private lazy var navigationHome: UINavigationController = {
        let navigationHome = UINavigationController(rootViewController: homeViewController)

        navigationHome.navigationBar.topItem?.backButtonTitle = ""
        navigationHome.navigationBar.topItem?.title = MagicLiteral.homeViewControllerTitle
        navigationHome.navigationBar.tintColor = .white
        navigationHome.navigationBar.standardAppearance = navigationBarAppearance
        navigationHome.navigationBar.scrollEdgeAppearance = navigationBarAppearance

        return navigationHome
    }()

    private lazy var navigationFavorite: UINavigationController = {
        let navigationFavorite = UINavigationController(rootViewController: favoriteViewController)

        navigationFavorite.navigationBar.topItem?.backButtonTitle = ""

        return navigationFavorite
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureAnimationView()
        configureTabBar()

        setViewControllers([navigationHome, navigationFavorite], animated: false)
    }

    private func configureTabBar() {
        homeViewController.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "HomeIcon"), selectedImage: UIImage(named: "HomeIcon"))
        favoriteViewController.tabBarItem = UITabBarItem(title: "즐겨찾기", image: UIImage(named: "FavoriteIcon"), selectedImage: UIImage(named: "FavoriteIcon"))

        tabBar.backgroundColor = UIColor(red: 0.38, green: 0.13, blue: 0.93, alpha: 1.00)
        tabBar.barTintColor = UIColor(red: 0.38, green: 0.13, blue: 0.93, alpha: 1.00)
        tabBar.isTranslucent = false
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .systemGray2
    }

    private func configureAnimationView() {
        view.addSubview(animationView)

        animationView.frame = view.bounds
        animationView.center = view.center
        animationView.alpha = 1

        animationView.play { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.animationView.alpha = 0
            }, completion: { _ in
                self.animationView.isHidden = true
                self.animationView.removeFromSuperview()
            })
        }
    }
}

