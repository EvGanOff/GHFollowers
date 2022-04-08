//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Евгений Ганусенко on 4/7/22.
//

import Foundation

/**
Для работы с сетью будем использовать Singlton
Плюсы: глобальный менеджер, доступная в любом месте программы
Минусы: Не тестируемый
**/

class NetworkManager {
    static let shared = NetworkManager()
    let baseURL = "https://api.github.com"

    private init() {}

    func getFollowes(userName: String, page: Int, complited: @escaping ([Follower]?, String?) -> Void) {
        let endpoint = baseURL + "/users/\(userName)/followers?per_page=100&page\(page)"
        guard let url = URL(string: endpoint) else {
            complited(nil, "This userName created invalid request")
            return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            if let _ = error {
                complited(nil, "Unuble to coplete your request. Please check your internet connection")
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                complited(nil, "Invalid response from the server, please try again")
                return
            }

            guard let data = data else {
                complited(nil, "The data received from the server was invalid. Please try again")
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                complited(followers, nil)
            } catch { complited(nil, "The data received from the server was invalid. Please try again") }
        }
        
        task.resume()
    }
}
