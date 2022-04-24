//
//  User.swift
//  GHFollowers
//
//  Created by Евгений Ганусенко on 3/30/22.
//

import Foundation
import UIKit

struct User: Codable, Hashable  {
    let login: String
    let avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: String
    let following: Int
    let followers: Int
    let createdAt: String
}

