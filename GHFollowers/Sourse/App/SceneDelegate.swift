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
        window?.rootViewController = GFTabBarController()
        window?.makeKeyAndVisible()
        configureNavigationBar()
    }

    func configureNavigationBar() {
        UINavigationBar.appearance().tintColor = .systemGreen
    }
}

