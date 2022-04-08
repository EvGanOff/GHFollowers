//
//  ErrorMessage.swift
//  GHFollowers
//
//  Created by Евгений Ганусенко on 4/8/22.
//

import Foundation

enum GFError: String, Error {
    case invaliedUserName = "This userName created invalid request"
    case unableToComplete = "Unable to coplete your request. Please check your internet connection"
    case invaliedRespons = "Invalid response from the server. Please try again"
    case invaliedData = "The data received from the server was invalid. Please try again"
}
