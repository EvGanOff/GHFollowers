//
//  GFFollowerItemVC.swift
//  GHFollowers
//
//  Created by Евгений Ганусенко on 4/26/22.
//

import UIKit

// Дочерний класс для GFItemInfoVC

class GFFollowerItemVC: GFItemInfoVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItem()
    }

    private func configureItem() {
        itemInfoViewFirst.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewSecond.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Followers")
    }
}
