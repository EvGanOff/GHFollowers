//
//  FolloverListViewController.swift
//  GHFollowers
//
//  Created by Евгений Ганусенко on 3/20/22.
//

import UIKit

class FolloverListViewController: UIViewController {

    var userName: String! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        // Наш Singlton для запроса в сеть
        NetworkManager.shared.getFollowes(userName: userName, page: 1) { followers, errorMessage in
            guard let follower = followers else {
                self.presentsGFAlertControllerOnMainTread(title: "Bad stuff", massage: errorMessage!, buttonTitle: "OK")
                return
            }

            print("Количество подписчиков = \(followers?.count ?? 0)")
            print(followers ?? [])
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
