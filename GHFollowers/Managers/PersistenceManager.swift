//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by Евгений Ганусенко on 4/29/22.
//

import Foundation

enum PresistenceActionType {
    case add, remove
}

enum PersistenceManager {
    static private let userDefaults = UserDefaults.standard

    enum Keys {
        static let favorites = "favorites"
    }

    static func updateWith(favorite: Follower, actionType: PresistenceActionType, completed: @escaping (GFError?) -> Void) {
        retrieveFollowers { result in
            switch result {
            case .success(let favorites):
                var retrivedFavorites = favorites
                switch actionType {
                case .add:
                    guard !retrivedFavorites.contains(favorite) else {
                        completed(.alreadyInFavorites)
                        return
                    }

                    retrivedFavorites.append(favorite)
                case .remove:
                    retrivedFavorites.removeAll { $0.login == favorite.login }
                }

                completed(save(favorites: retrivedFavorites))
            case .failure(let error):
                completed(error)
            }
        }
    }

    static func retrieveFollowers(completed: @escaping (Result<[Follower], GFError>) -> Void) {
        guard let favoritesData = userDefaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }

        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode([Follower].self, from: favoritesData)
            completed(.success(user))
        } catch { completed(.failure(.unableToFavorites)) }
    }

    static func save(favorites: [Follower]) -> GFError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            userDefaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorites
        }
    }
}
