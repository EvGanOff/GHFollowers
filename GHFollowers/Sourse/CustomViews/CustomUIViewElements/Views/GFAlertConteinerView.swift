//
//  GFAlertConteinerView.swift
//  GHFollowers
//
//  Created by Евгений Ганусенко on 5/3/22.
//

import UIKit

class GFAlertConteinerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
       backgroundColor = .systemBackground
       layer.cornerRadius = 20
       layer.borderWidth = 2
       layer.borderColor = UIColor.white.cgColor
       translatesAutoresizingMaskIntoConstraints = false
    }

}
