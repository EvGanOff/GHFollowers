//
//  FavoritesListViewController.swift
//  GHFollowers
//
//  Created by Евгений Ганусенко on 3/13/22.
//

import UIKit

class FavoritesListViewController: UIViewController {

    let tableView = UITableView()
    var favorites: [Follower] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }

    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Favorites" 
        getFavorites()
    }

    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80

        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }

    func getFavorites() {


        PersistenceManager.retrieveFollowers { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let favorites):

                if favorites.isEmpty {
                    self.showEmptyStateView(with: "No favorites?\nAdd one on the fallower screen", in: self.view)
                } else {
                    self.favorites = favorites
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.view.bringSubviewToFront(self.tableView)
                    }
                }

            case .failure(let error):
                self.presentsGFAlertControllerOnMainTread(title: "Что то пошло не так", massage: error.rawValue, buttonTitle: "ОК")
            }
        }
    }
}

// MARK: - TableViewDelegate
extension FavoritesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destVC = FollowerListViewController()

        destVC.userName = favorite.login
        destVC.title = favorite.login

        navigationController?.pushViewController(destVC, animated: true)
    }

    // Удаление ячейки
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }

        let favorite = favorites[indexPath.row]
        favorites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)

        PersistenceManager.updateWith(favorite: favorite, actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else { return }
            self.presentsGFAlertControllerOnMainTread(title: "Unable to remove", massage: error.rawValue, buttonTitle: "OK")
        }
    }

}

// MARK: - TableViewDataSource
extension FavoritesListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)

        return cell
    }
}
