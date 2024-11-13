//
//  GitHubForkService.swift
//  GithubUsers
//
//  Created by mohamed tahoon on 12/11/2024.
//

import Foundation
import Combine

// MARK: - GitHubForkService
class GitHubForkService {
    private let networkManager = NetworkManager.shared
    
    func fetchForks(owner: String, repo: String) -> AnyPublisher<[GitHubForksModel], Error> {
        guard let url = GitHubAPI.url(for: GitHubAPI.Endpoints.repoForks(owner: owner, repo: repo)) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return networkManager.fetchData(from: url, type: [GitHubForksModel].self)
    }
}
