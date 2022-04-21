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

    func getFollowes(userName: String, page: Int, complited: @escaping (Result<[Follower], GFError>) -> Void) {
        let endpoint = baseURL + "/users/\(userName)/followers?per_page=100&page=\(page)"
        guard let url = URL(string: endpoint) else {
            complited(.failure(.invaliedUserName))
            return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            if let _ = error {
                complited(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                complited(.failure(.unableToComplete))
                return
            }

            guard let data = data else {
                complited(.failure(.invaliedData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                complited(.success(followers))
            } catch { complited(.failure(.invaliedData)) }
        }
        
        task.resume()
    }
}
