//
//  GFTabBarController.swift
//  GHFollowers
//
//  Created by Евгений Ганусенко on 5/3/22.
//

import UIKit

class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [createSearchNC(), createFaoritesNC()]
        
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
}
