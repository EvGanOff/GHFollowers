//
//  GFEmptyStateView.swift
//  GHFollowers
//
//  Created by Евгений Ганусенко on 4/20/22.
//

import UIKit

class GFEmptyStateView: UIView {
    let messageLabel = GFTitleLabel(textAligment: .center, fontSize: 30)
    let logoImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(message: String) {
        super.init(frame: .zero)
        messageLabel.text = message
        configure()
    }

    private func configure() {
        addSubview(messageLabel)
        addSubview(logoImageView)

        messageLabel.numberOfLines = 5
        messageLabel.textColor = .secondaryLabel

        logoImageView.image = UIImage(named: "empty-state-logo")
        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor,
                constant: -Metrics.messageLabelCenterYAnchorConstraint),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                constant: Metrics.messageLabelAnchorPadding),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                constant: -Metrics.messageLabelAnchorPadding),
            messageLabel.heightAnchor.constraint(equalToConstant: Metrics.messageLabelHeightAnchor),

            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor,
                multiplier: Metrics.logoImageViewWidthAndHeightAnchor),
            logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor,
                multiplier: Metrics.logoImageViewWidthAndHeightAnchor),
            logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                constant: Metrics.logoImageViewTrailingAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                constant: Metrics.logoImageViewBottomAnchor)
        ])
    }

    private struct Metrics {
        static let messageLabelCenterYAnchorConstraint: CGFloat = 150
        static let messageLabelAnchorPadding: CGFloat = 40
        static let messageLabelHeightAnchor: CGFloat = 200

        static let logoImageViewWidthAndHeightAnchor: CGFloat = 1.3
        static let logoImageViewTrailingAnchor: CGFloat = 170
        static let logoImageViewBottomAnchor: CGFloat = 40
    }
}
