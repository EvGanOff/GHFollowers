//
//  InfoVC.swift
//  GHFollowers
//
//  Created by Евгений Ганусенко on 4/24/22.
//

import UIKit

class InfoVC: UIViewController {

    private lazy var headerView: UIView = {
        let headerView = UIView()
        headerView.backgroundColor = .systemGray5
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.layer.cornerRadius = 10

        return headerView
    }()

    var userName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector (dissmisVC))
        navigationItem.rightBarButtonItem = cancelButton
        layoutUI()

        NetworkManager.shared.getUserInfo(userName: userName) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
                }

            case .failure(let error):
                self.presentsGFAlertControllerOnMainTread(title: "Что-то пошло не так", massage: error.rawValue, buttonTitle: "OK")
            }
        }
    }

    func layoutUI() {
        view.addSubview(headerView)
        let padding: CGFloat = 20

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            headerView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }

    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }

@objc
    func dissmisVC() {
        dismiss(animated: true)
    }
}