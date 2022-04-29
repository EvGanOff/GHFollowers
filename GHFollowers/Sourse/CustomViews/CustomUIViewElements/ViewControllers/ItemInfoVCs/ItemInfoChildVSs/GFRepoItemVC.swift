//
//  GFRepoItemVC.swift
//  GHFollowers
//
//  Created by Евгений Ганусенко on 4/26/22.
//

import UIKit

// Дочерний класс для GFItemInfoVC

class GFRepoItemVC: GFItemInfoVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItem()
    }

    private func configureItem() {
        itemInfoViewFirst.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewSecond.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPink, title: "GitHub Profile")
    }

    override func actionButtonTapped() {
        delegate.didTabGitHubProfile(for: user)
    }
}
