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
        let url = URL(string: "https://api.github.com/repos/\(owner)/\(repo)/forks")!
        return networkManager.fetchData(from: url, type: [GitHubForksModel].self)
    }
}
