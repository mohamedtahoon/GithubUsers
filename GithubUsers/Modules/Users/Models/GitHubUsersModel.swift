//
//  UsersResponseModel.swift
//  GithubUsers
//
//  Created by mohamed tahoon on 11/11/2024.
//

import Foundation

struct GitHubUsersModel: Identifiable, Codable {
    let id: Int
    let login: String
    let avatar_url: String
    let url: String?
    let html_url: String?
    let followers_url: String
    let following_url: String?
    let gists_url: String?
    let starred_url: String?
    let subscriptions_url: String?
    let organizations_url: String?
    let repos_url: String?
    let events_url: String?
    let received_events_url: String?
    let type: String?
    let site_admin: Bool?
    var followersCount: Int?
    var reposCount: Int?
}
