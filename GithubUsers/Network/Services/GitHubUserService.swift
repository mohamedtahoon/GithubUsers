//
//  GitHubUserService.swift
//  GithubUsers
//
//  Created by mohamed tahoon on 12/11/2024.
//

import Foundation
import Combine

// MARK: - GitHubUserService
class GitHubUserService {
    private let networkManager = NetworkManager.shared
    
    func fetchUsers() -> AnyPublisher<[GitHubUsersModel], Error> {
        let url = URL(string: "https://api.github.com/users")!
        return networkManager.fetchData(from: url, type: [GitHubUsersModel].self)
    }
    
    func fetchFollowersCount(url: String) -> AnyPublisher<Int, Error> {
        guard let url = URL(string: url) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return networkManager.fetchData(from: url, type: [GitHubUsersModel].self)
            .map { $0.count }
            .eraseToAnyPublisher()
    }
    
    func fetchFullUserDetails(for user: GitHubUsersModel) -> AnyPublisher<GitHubUsersModel, Error> {
        Publishers.Zip(fetchFollowersCount(url: user.followers_url), GitHubRepoService().fetchRepositories(username: user.login))
            .map { followersCount, repos in
                var updatedUser = user
                updatedUser.followersCount = followersCount
                updatedUser.reposCount = repos.count
                return updatedUser
            }
            .eraseToAnyPublisher()
    }
}
