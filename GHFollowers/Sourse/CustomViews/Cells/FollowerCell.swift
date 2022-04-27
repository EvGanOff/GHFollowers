//
//  FollowerCell.swift
//  GHFollowers
//
//  Created by Евгений Ганусенко on 4/8/22.
//

import UIKit

class FollowerCell: UICollectionViewCell {
    static let userID = "FollowerCell"

    let avatarImageView = GFAvatarImageView(frame: .zero)
    let userNameLabel = GFTitleLabel(textAligment: .center, fontSize: 16)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(follower: Follower) {
        userNameLabel.text = follower.login
        avatarImageView.downloadAvatarImage(from: follower.avatarUrl)
    }

    private func configure() {
        addSubview(avatarImageView)
        addSubview(userNameLabel)

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: Metrics.padding),
            avatarImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: Metrics.padding),
            avatarImageView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Metrics.padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),

            userNameLabel.topAnchor.constraint(
                equalTo: avatarImageView.bottomAnchor, constant: Metrics.userNameLabelPadding),
            userNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.padding),
            userNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Metrics.padding),
            userNameLabel.heightAnchor.constraint(equalToConstant: Metrics.userNameLabelHeightAnchorPadding)
        ])
    }

    private struct Metrics {
        static let padding: CGFloat = 8
        static let userNameLabelPadding: CGFloat = 10
        static let userNameLabelHeightAnchorPadding: CGFloat = 20
    }
}
