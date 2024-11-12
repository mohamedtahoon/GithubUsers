//
//  GitHubUsersViewModel.swift
//  GithubUsers
//
//  Created by mohamed tahoon on 11/11/2024.
//

import Foundation
import Combine

class GitHubUsersViewModel: ObservableObject {
    @Published var users: [GitHubUsersModel] = []
    @Published var isLoading = false
    @Published var errorMessage: IdentifiableError?
    
    private var userService = GitHubUserService()
    private var cancellables = Set<AnyCancellable>()
    
    // Dependency Injection for testability
    init(userService: GitHubUserService = GitHubUserService()) {
        self.userService = userService
    }
    
    func fetchUsers() {
        // Check if users have already been fetched 
        // to prevent fetching data again after navigation back to users view
        guard users.isEmpty else { return }
        
        isLoading = true
        userService.fetchUsers()
            .flatMap { [weak self] users -> AnyPublisher<[GitHubUsersModel], Error> in
                guard let self = self else {
                    return Just(users)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                
                // Fetch full user details for each user
                let userDetailsFetches = users.map { user in
                    self.userService.fetchFullUserDetails(for: user)
                        .catch { _ in Just(user).setFailureType(to: Error.self).eraseToAnyPublisher() }
                        .eraseToAnyPublisher()
                }
                
                // Collect results from all the publishers into an array and return as AnyPublisher
                return Publishers.MergeMany(userDetailsFetches)
                    .collect()
                    .map { $0 }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.handleError(error)
                }
            }, receiveValue: { [weak self] updatedUsers in
                self?.users = updatedUsers
            })
            .store(in: &cancellables)
    }
    
    private func handleError(_ error: Error) {
        errorMessage = IdentifiableError(message: error.localizedDescription)
    }
}
