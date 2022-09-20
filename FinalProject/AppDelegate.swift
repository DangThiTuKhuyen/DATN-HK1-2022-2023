//
//  AppDelegate.swift
//  FinalProject
//
//  Created by Bien Le Q. on 8/26/19.
//  Copyright © 2019 Asiantech. All rights reserved.
//

import UIKit
import SVProgressHUD

typealias HUD = SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        configTabbar()
        LocationManager.shared().request()
        return true
    }

    // MARK: - Private func
    func configTabbar() {
        let homeVC = HomeViewController()
        let homeViewModel = HomeViewModel()
        homeVC.viewModel = homeViewModel
        let homeNavi = UINavigationController(rootViewController: homeVC)
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "home"), selectedImage: #imageLiteral(resourceName: "home_fill"))

        let searchVC = SearchViewController()
        let searchViewModel = SearchViewModel()
        searchVC.viewModel = searchViewModel
        let searchNavi = UINavigationController(rootViewController: searchVC)
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: #imageLiteral(resourceName: "search"), selectedImage: #imageLiteral(resourceName: "search_fill"))

        let favoriteVC = FavoriteViewController()
        let favoriteNavi = UINavigationController(rootViewController: favoriteVC)
        favoriteVC.tabBarItem = UITabBarItem(title: "Favorite", image: #imageLiteral(resourceName: "favorite"), selectedImage: #imageLiteral(resourceName: "favorite_fill"))
        let favoriteViewModel = FavoriteViewModel()
        favoriteVC.viewModel = favoriteViewModel

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [homeNavi, searchNavi, favoriteNavi]
        tabBarController.tabBar.tintColor = .black
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
    }
}
