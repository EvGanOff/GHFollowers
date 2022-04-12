//
//  FolloverListViewController.swift
//  GHFollowers
//
//  Created by Евгений Ганусенко on 3/20/22.
//

import UIKit

class FolloverListViewController: UIViewController {

    var userName: String! = nil
    var collectionView: UICollectionView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getFollowers()
        configureCollectionCell()
        configureViewController()
    }

    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func configureCollectionCell() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createThreeCulumnFlowLayout())
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.userID)
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemPink
    }

    func getFollowers() {
        // Наш Singlton для запроса в сеть
        NetworkManager.shared.getFollowes(userName: userName, page: 1) { result in
            switch result {
            case .success(let followers):
                print(followers)
            case .failure(let error):
                self.presentsGFAlertControllerOnMainTread(title: "Bad stuff", massage: error.rawValue, buttonTitle: "OK")

            }
        }
    }

    func createThreeCulumnFlowLayout() -> UICollectionViewFlowLayout {
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
