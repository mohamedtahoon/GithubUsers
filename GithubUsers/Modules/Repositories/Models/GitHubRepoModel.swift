//
//  GitHubRepoModel.swift
//  GithubUsers
//
//  Created by mohamed tahoon on 11/11/2024.
//

import Foundation

struct GitHubRepoModel: Identifiable, Codable {
    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let license: License?
    let owner: Owner?
    let htmlUrl: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case fullName = "full_name"
        case description
        case license
        case owner
        case htmlUrl = "html_url"
        case createdAt = "created_at"
    }
}

struct License: Codable {
    let name: String
}

struct Owner: Codable {
    let login: String
    let id: Int
    let avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case id
        case avatarUrl = "avatar_url"
    }
}
