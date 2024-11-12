//
//  GitHubRepoService.swift
//  GithubUsers
//
//  Created by mohamed tahoon on 12/11/2024.
//

import Foundation
import Combine

// MARK: - GitHubRepoService
class GitHubRepoService {
    private let networkManager = NetworkManager.shared
    
    func fetchRepositories(username: String) -> AnyPublisher<[GitHubRepoModel], Error> {
        let url = URL(string: "https://api.github.com/users/\(username)/repos")!
        return networkManager.fetchData(from: url, type: [GitHubRepoModel].self)
    }
}
