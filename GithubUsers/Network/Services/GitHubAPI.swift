//
//  GitHubAPI.swift
//  GithubUsers
//
//  Created by mohamed tahoon on 12/11/2024.
//

import Foundation

struct GitHubAPI {
    static let baseURL = "https://api.github.com"
    
    struct Endpoints {
        static func userRepos(username: String) -> String {
            return "\(baseURL)/users/\(username)/repos"
        }
        
        static func userDetails(username: String) -> String {
            return "\(baseURL)/users/\(username)"
        }
        
        static let users = "\(baseURL)/users"
        
        static func repoForks(owner: String, repo: String) -> String {
            return "\(baseURL)/repos/\(owner)/\(repo)/forks"
        }
    }
    
    static func url(for endpoint: String) -> URL? {
        return URL(string: endpoint)
    }
}
