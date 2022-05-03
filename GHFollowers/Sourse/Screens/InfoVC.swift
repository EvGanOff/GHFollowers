//
//  InfoVC.swift
//  GHFollowers
//
//  Created by Евгений Ганусенко on 4/24/22.
//

import UIKit

protocol InfoVCDelegate: AnyObject {
    func didTabGitHubProfile(for user: User)
    func didTabGetFollowers(for user: User)
}

class InfoVC: GFDataLoadingVC {

    var itemViews: [UIView] = []

    let headerView = UIView()
    let itemViewFirst = UIView()
    let itemViewSecond = UIView()
    let dateLabel = GFBodyLabel(textAligment: .center)

    var userName: String!
    weak var delegate: FollowerListVCDelegate!

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
                    self.configureIUIElements(with: user)
                }

            case .failure(let error):
                self.presentsGFAlertControllerOnMainTread(title: "Что-то пошло не так", massage: error.rawValue, buttonTitle: "OK")
            }
        }
    }

    func configureIUIElements(with user: User) {
        let repoItemVC = GFRepoItemVC(user: user)
        repoItemVC.delegate = self

        let followerItemVC = GFFollowerItemVC(user: user)
        followerItemVC.delegate = self

        self.add(childVC: repoItemVC, to: itemViewFirst)
        self.add(childVC: followerItemVC, to: itemViewSecond)
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: headerView)
        self.dateLabel.text = user.createdAt.convertToMonthYearFormat()
    }

    func layoutUI() {
        let padding: CGFloat = 20
        let heightAnchor: CGFloat = 140
        itemViews = [headerView, itemViewFirst, itemViewSecond, dateLabel]
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

            dateLabel.topAnchor.constraint(equalTo: itemViewSecond.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }


    @objc func dissmisVC() {
        dismiss(animated: true)
    }
}

extension InfoVC: InfoVCDelegate {

    func didTabGitHubProfile(for user: User) {
        // показать Safari view controller
        guard let url = URL(string: user.htmlUrl) else { presentsGFAlertControllerOnMainTread(title: "Invalid URL", massage: "This url attached to this user is invalid.", buttonTitle: "OK")
            return
        }

        presenSafariVC(from: url)
    }

    func didTabGetFollowers(for user: User) {
        // dismiss view controller
        // tell follower list screen with new follower
        guard user.followers != 0 else {
            presentsGFAlertControllerOnMainTread(title: "No followers", massage: "У пользователя нет подписчиков 😔.", buttonTitle: "Фигово")
            return
        }
        delegate.didRequestFollowers(for: user.login)
        dissmisVC()
    }
}
