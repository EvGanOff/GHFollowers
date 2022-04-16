//
//  UIHelper.swift
//  GHFollowers
//
//  Created by Евгений Ганусенко on 4/16/22.
//

import UIKit

struct UIHelper {

    static func createThreeCulumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimalItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimalItemSpacing * 2)
        let itemWidth = availableWidth / 3

        let flowLayuot = UICollectionViewFlowLayout()
        flowLayuot.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayuot.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)

        return flowLayuot
    }
}
