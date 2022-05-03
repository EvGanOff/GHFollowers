//
//  FollowerListViewController.swift
//  GHFollowers
//
//  Created by Евгений Ганусенко on 3/20/22.
//

import UIKit

protocol FollowerListVCDelegate: AnyObject {
    func didRequestFollowers(for userName: String)
}

class FollowerListViewController: GFDataLoadingVC {

    enum Section {
        case main
    }

    var followers: [Follower] = []
    var userName: String? = nil
    var page = 1
    var filteredFollowers: [Follower] = []
    var hasMoreFollower = true
    var collectionView: UICollectionView!
    var collectionDataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    var isSearching = false

    init(userName: String) {
        super.init(nibName: nil, bundle: nil)
        self.userName = userName
        title = userName
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionCell()
        getFollowers(userName: userName ?? "", page: page)
        configureDataSource()
        configureSearchController()
    }

    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector (addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
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

    @objc func addButtonTapped() {
        print("Add Button was tapped")
        //showLoadingView()

        NetworkManager.shared.getUserInfo(userName: (userName ?? "")) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)

                PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
                    guard let self = self else { return }

                    guard let error = error else {
                        self.presentsGFAlertControllerOnMainTread(title: "Seccess!", massage: "Вы уже успешно добавили пользователя в избранные ⭐️.", buttonTitle: "ОК")
                        return
                    }

                    self.presentsGFAlertControllerOnMainTread(title: "Что то пошло не так", massage: error.rawValue, buttonTitle: "ОК")
                }
            case .failure(let error):
                self.presentsGFAlertControllerOnMainTread(title: "Что то пошло не так", massage: error.rawValue, buttonTitle: "ОК")
            }
        }
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

    // MARK: - ScrollView
extension FollowerListViewController: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeigth = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeigth - height {
            guard hasMoreFollower else { return }
            page += 1
            getFollowers(userName: (userName ?? ""), page: page)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]


        let destVC = InfoVC()
        destVC.userName = follower.login
        destVC.delegate = self
        let navigation = UINavigationController(rootViewController: destVC)
        present(navigation, animated: true)
    }
}


    // MARK: - CollectionViewDataSource
extension FollowerListViewController {

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
extension FollowerListViewController: UISearchResultsUpdating, UISearchBarDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }

        isSearching = true
        filteredFollowers = followers.filter({ $0.login.lowercased().contains(filter.lowercased()) })
        updateData(on: filteredFollowers)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: followers)
    }
}

extension FollowerListViewController: FollowerListVCDelegate {
    func didRequestFollowers(for userName: String) {
        // подписчики юзера обновление таблицы
        self.userName = userName
        title = userName
        page = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.setContentOffset(.zero, animated: true)
        getFollowers(userName: userName, page: page)
        navigationController?.navigationBar.tintColor = .systemPurple
    }
}
