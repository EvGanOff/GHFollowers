//
//  User.swift
//  GHFollowers
//
//  Created by Евгений Ганусенко on 3/30/22.
//

import Foundation
import UIKit

struct User: Codable  {
    var login: String
    var avatarUrl: String

    var name: String?
    var location: String?
    var bio: String?

    var publicReps: Int
    var publicGists: Int
    
    var htmlUrl: String
    var following: Int
    var followers: Int
    var createAt: String
}
