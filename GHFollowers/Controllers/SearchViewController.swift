//
//  SearchViewController.swift
//  GHFollowers
//
//  Created by Евгений Ганусенко on 3/13/22.
//

import UIKit

class SearchViewController: UIViewController {

    let logoImageView = UIImageView()
    let userNameTextField = GFTextField()
    let actionButton = GFButton(backgraundColor: .systemGreen, title: "Get Followers")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogoImageView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    func configureLogoImageView() {
        view.addSubview(logoImageView)
        view.addSubview(userNameTextField)
        view.addSubview(actionButton)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "gh-logo")
    
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constats.logoImageViewTopAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: Constats.logoImageViewHeightAndWidAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: Constats.logoImageViewHeightAndWidAnchor),

            userNameTextField.topAnchor.constraint(
                equalTo: logoImageView.bottomAnchor,
                constant: Constats.userNameTextFieldTopAnchor),
            userNameTextField.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constats.userNameTextFieldLeadingAnchor),
            userNameTextField.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: Constats.userNameTextFieldTrailingAnchor),
            userNameTextField.heightAnchor.constraint(equalToConstant: Constats.userNameTextFieldHeightAnchor),

            actionButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: Constats.actionButtonBottomAnchor),
            actionButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constats.actionButtonLeadingAnchor),
            actionButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: Constats.actionButtonTrailingAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: Constats.actionButtonHeightAnchor)
        ])
    }
}

struct Constats {
    static let logoImageViewTopAnchor: CGFloat = 80
    static let logoImageViewHeightAndWidAnchor: CGFloat = 200

    static let userNameTextFieldTopAnchor: CGFloat = 50
    static let userNameTextFieldLeadingAnchor: CGFloat = 50
    static let userNameTextFieldTrailingAnchor: CGFloat = -50
    static let userNameTextFieldHeightAnchor: CGFloat = 50

    static let actionButtonBottomAnchor: CGFloat = -50
    static let actionButtonLeadingAnchor: CGFloat = 50
    static let actionButtonTrailingAnchor: CGFloat = -50
    static let actionButtonHeightAnchor: CGFloat = 50
}
