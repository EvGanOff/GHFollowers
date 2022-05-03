//
//  SearchViewController.swift
//  GHFollowers
//
//  Created by Евгений Ганусенко on 3/13/22.
//

import UIKit

class SearchViewController: GFDataLoadingVC {

    // MARK: - Properties
    let logoImageView = UIImageView()
    let userNameTextField = GFTextField()
    let actionButton = GFButton(backgraundColor: .systemGreen, title: "Get Followers")
    var isUserNameEturned: Bool {
        return userNameTextField.text?.isEmpty ?? false
    }
    var logoImageViewTopConstraint: NSLayoutConstraint!

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupHierarchy()
        configureLogoImageView()
        configureUserNameTextField()
        configureActionButton()
        createDismissKeyboardTapGesture()
    }

    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userNameTextField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - SetupHierarchy
    func setupHierarchy() {
        view.addSubview(logoImageView)
        view.addSubview(userNameTextField)
        view.addSubview(actionButton)
    }

    @objc func pushFollowrListViewConrolller() {
        guard isUserNameEturned != true else {
            presentsGFAlertControllerOnMainTread(title: "Вы не вввели имя", massage: "Пожалуйста введите имя! Нам необходимо знать, кого искать 😀", buttonTitle: "Оки")
            return

        }

        userNameTextField.resignFirstResponder()

        let followerVC = FollowerListViewController(userName: userNameTextField.text ?? "")
        navigationController?.pushViewController(followerVC, animated: true)
    }

    // MARK: - ConfigureViews
    func configureLogoImageView() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.mainLogo 

        let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80
        logoImageViewTopConstraint = logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant)
        logoImageViewTopConstraint.isActive = true
    
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: Constats.logoImageViewHeightAndWidAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: Constats.logoImageViewHeightAndWidAnchor),
        ])
    }

    func configureUserNameTextField() {
        userNameTextField.delegate = self
        
        NSLayoutConstraint.activate([
            userNameTextField.topAnchor.constraint(
                equalTo: logoImageView.bottomAnchor,
                constant: Constats.userNameTextFieldTopAnchor),
            userNameTextField.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constats.userNameTextFieldLeadingAnchor),
            userNameTextField.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: Constats.userNameTextFieldTrailingAnchor),
            userNameTextField.heightAnchor.constraint(equalToConstant: Constats.userNameTextFieldHeightAnchor)
        ])
    }

    func configureActionButton() {
        actionButton.addTarget(self, action: #selector(pushFollowrListViewConrolller), for: .touchUpInside)
        NSLayoutConstraint.activate([
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

// MARK: - Extensions
extension SearchViewController {
    private func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector (UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowrListViewConrolller()
        return true
    }
}

// MARK: - Constats and Metrics
private struct Constats {
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


