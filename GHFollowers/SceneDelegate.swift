//
//  SceneDelegate.swift
//  GHFollowers
//
//  Created by Евгений Ганусенко on 3/13/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if #available(iOS 13.0, *) {
           let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
           tabBarAppearance.configureWithDefaultBackground()
           if #available(iOS 15.0, *) {
              UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
           }
        }

        guard let windowSeane = (scene as? UIWindowScene) else { return }

        window = UIWindow(frame: windowSeane.coordinateSpace.bounds)
        window?.windowScene = windowSeane
        window?.rootViewController = createTabBar()
        window?.makeKeyAndVisible()
    }

    func createSearchNC() -> UINavigationController {
        let searhVC = SearchViewController()
        searhVC.title = "Search"
        searhVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        return UINavigationController(rootViewController: searhVC)
    }

    func createFaoritesNC() -> UINavigationController {
        let favoritesVC = FavoritesListViewController()
        favoritesVC.title = "Favorites"
        favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        return UINavigationController(rootViewController: favoritesVC)
    }

    func createTabBar() -> UITabBarController {
        let tabBar = UITabBarController()
        UITabBar.appearance().tintColor = .systemGreen
        tabBar.viewControllers = [createSearchNC(), createFaoritesNC()]

        return tabBar
    }
}

