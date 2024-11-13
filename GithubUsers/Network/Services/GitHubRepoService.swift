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
        guard let url = GitHubAPI.url(for: GitHubAPI.Endpoints.userRepos(username: username)) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return networkManager.fetchData(from: url, type: [GitHubRepoModel].self)
    }
}
