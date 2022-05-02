//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Евгений Ганусенко on 4/7/22.
//

import Foundation
import UIKit

/**
Для работы с сетью будем использовать Singlton
Плюсы: глобальный менеджер, доступная в любом месте программы
Минусы: Не тестируемый
**/

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://api.github.com"
    let cash = NSCache<NSString, UIImage>()

    private init() {}

    func getFollowes(userName: String, page: Int, completed: @escaping (Result<[Follower], GFError>) -> Void) {
        // 1) Получить API
        let endpoint = baseURL + "/users/\(userName)/followers?per_page=100&page=\(page)"

        // 2) Создание GET запроса (URL)
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invaliedUserName))
            return }

        // 3) Инициализировать сессию
        // 4) Создать запрос dataTask ( 3) shared - иницифлизирует сессию по .default)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // 5) Обработать полученную информацию
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.unableToComplete))
                return
            }

            guard let data = data else {
                completed(.failure(.invaliedData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(.success(followers))
            } catch {
                completed(.failure(.invaliedData))
            }
        }
        
        task.resume()
    }

    func getUserInfo(userName: String, completed: @escaping (Result<User, GFError>) -> Void) {
        let endpoint = baseURL + "/users/\(userName)"
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invaliedUserName))
            return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.unableToComplete))
                return
            }

            guard let data = data else {
                completed(.failure(.invaliedData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let user = try decoder.decode(User.self, from: data)
                completed(.success(user))
            } catch { completed(.failure(.invaliedData)) }
        }

        task.resume()
    }
}
