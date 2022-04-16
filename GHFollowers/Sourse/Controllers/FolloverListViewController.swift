//
//  FolloverListViewController.swift
//  GHFollowers
//
//  Created by Евгений Ганусенко on 3/20/22.
//

import UIKit

class FolloverListViewController: UIViewController {

    enum Section {
        case main
    }

    var followers: [Follower] = []
    var userName: String! = nil
    var collectionView: UICollectionView!
    var collectionDataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getFollowers()
        configureViewController()
        configureCollectionCell()
        configureDataSource()
    }

    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func configureCollectionCell() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeCulumnFlowLayout(in: view))
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.userID)
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
    }

    func getFollowers() {
        // Наш Singlton для запроса в сеть
        NetworkManager.shared.getFollowes(userName: userName, page: 1) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let followers):
                self.followers = followers
                self.updateData()

            case .failure(let error):
                self.presentsGFAlertControllerOnMainTread(title: "Bad stuff", massage: error.rawValue, buttonTitle: "OK")

            }
        }
    }

    

    func configureDataSource() {
        collectionDataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView) { collectionView, indexPath, follower in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.userID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)

            return cell
        }
    }

    func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)

        DispatchQueue.main.async {
            self.collectionDataSource.apply(snapshot, animatingDifferences: true)

        }
    }
}
