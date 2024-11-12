//
//  GitHubRepoModel.swift
//  GithubUsers
//
//  Created by mohamed tahoon on 11/11/2024.
//

import Foundation

struct GitHubRepoModel: Identifiable, Decodable {
    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let license: License?
    
    struct License: Decodable {
        let name: String
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case fullName = "full_name"
        case description
        case license
    }
}
