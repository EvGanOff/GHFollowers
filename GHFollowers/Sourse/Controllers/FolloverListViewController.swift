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
    var page = 1
    var filteredFollowers: [Follower] = []
    var hasMoreFollower = true
    var collectionView: UICollectionView!
    var collectionDataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionCell()
        getFollowers(userName: userName, page: page)
        configureDataSource()
        configureSearchController()
    }

    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func configureCollectionCell() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeCulumnFlowLayout(in: view))
        collectionView.delegate = self
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.userID)
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
    }

    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Найти"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }

    func getFollowers(userName: String, page: Int) {
        showLoadingView()

        // Наш Singlton для запроса в сеть
        NetworkManager.shared.getFollowes(userName: userName, page: page ) { [weak self] result in
            guard let self = self else { return }
            self.dissmisLoadingView()
            switch result {
            case .success(let followers):
                if followers.count < 100   {
                    self.hasMoreFollower = false
                }

                self.followers.append(contentsOf: followers)
                if self.followers.isEmpty {
                    let message = "К сожалению, у пользователя нет подписчиков 😕, но вы можете стать первым 😉."
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: message, in: self.view)
                    }
                    return
                }

                self.updateData(on: self.followers)
            case .failure(let error):
                self.presentsGFAlertControllerOnMainTread(title: "Bad stuff", massage: error.rawValue, buttonTitle: "OK")

            }
        }
    }
}

    // MARK: - CollectionViewDataSource
extension FolloverListViewController: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeigth = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeigth - height {
            guard hasMoreFollower else { return }
            page += 1
            getFollowers(userName: userName, page: page)
        }
    }
}


    // MARK: - CollectionViewDataSource
extension FolloverListViewController {

    func configureDataSource() {
        collectionDataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView) { collectionView, indexPath, follower in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.userID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)

            return cell
        }
    }

    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)

        DispatchQueue.main.async {
            self.collectionDataSource.apply(snapshot, animatingDifferences: true)

        }
    }
}

// MARK: - SearchController
extension FolloverListViewController: UISearchResultsUpdating, UISearchBarDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }

        filteredFollowers = followers.filter({ $0.login.lowercased().contains(filter.lowercased()) })
        updateData(on: filteredFollowers)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
         updateData(on: followers)
    }
}
