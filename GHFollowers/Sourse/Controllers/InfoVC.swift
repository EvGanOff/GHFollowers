//
//  InfoVC.swift
//  GHFollowers
//
//  Created by Евгений Ганусенко on 4/24/22.
//

import UIKit

class InfoVC: UIViewController {

    var itemViews: [UIView] = []

    let headerView = UIView()
    let itemViewFirst = UIView()
    let itemViewSecond = UIView()

    var userName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        layoutUI()
        getUserInfo()
    }

    func configureVC() {
        view.backgroundColor = .systemBackground
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector (dissmisVC))
        navigationItem.rightBarButtonItem = cancelButton
    }

    func getUserInfo() {

        NetworkManager.shared.getUserInfo(userName: userName) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
                    self.add(childVC: GFRepoItemVC(user: user), to: self.itemViewFirst)
                    self.add(childVC: GFFollowerItemVC(user: user), to: self.itemViewSecond)
                }

            case .failure(let error):
                self.presentsGFAlertControllerOnMainTread(title: "Что-то пошло не так", massage: error.rawValue, buttonTitle: "OK")
            }
        }
    }

    func layoutUI() {
        let padding: CGFloat = 20
        let heightAnchor: CGFloat = 140
        itemViews = [headerView, itemViewFirst, itemViewSecond]
        itemViews.forEach { views in
            view.addSubview(views)
            views.translatesAutoresizingMaskIntoConstraints = false
            views.layer.cornerRadius = 10

            NSLayoutConstraint.activate([
                views.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                views.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        }

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            headerView.heightAnchor.constraint(equalToConstant: 180),

            itemViewFirst.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewFirst.heightAnchor.constraint(equalToConstant: heightAnchor),

            itemViewSecond.topAnchor.constraint(equalTo: itemViewFirst.bottomAnchor, constant: padding),
            itemViewSecond.heightAnchor.constraint(equalToConstant: heightAnchor),
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
