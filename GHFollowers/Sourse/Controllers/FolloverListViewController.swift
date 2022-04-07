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

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
