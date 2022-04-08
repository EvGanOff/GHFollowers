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
        NetworkManager.shared.getFollowes(userName: userName, page: 1) { result in
            switch result {
            case .success(let followers):
                print(followers)
            case .failure(let error):
                self.presentsGFAlertControllerOnMainTread(title: "Bad stuff", massage: error.rawValue, buttonTitle: "OK")

            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
