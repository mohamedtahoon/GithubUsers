//
//  ForksResponseModel.swift
//  GithubUsers
//
//  Created by mohamed tahoon on 11/11/2024.
//

import Foundation

struct GitHubForksModel: Identifiable, Codable {
    let id: Int
    let name: String
    let full_name: String
    let description: String
}
