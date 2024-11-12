//
//  GitHubRepositoriesViewModel.swift
//  GithubUsers
//
//  Created by mohamed tahoon on 11/11/2024.
//

import Foundation
import Combine
import SwiftUI

class GitHubRepositoriesViewModel: ObservableObject {
    @Published var repositories: [GitHubRepoModel] = []
    @Published var isLoading = false
    @Published var errorMessage: IdentifiableError?
    
    private let repoService = GitHubRepoService()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchRepositories(username: String) {
        isLoading = true
        
        repoService.fetchRepositories(username: username)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = IdentifiableError(message: error.localizedDescription)
                }
            }, receiveValue: { repositories in
                self.repositories = repositories
            })
            .store(in: &cancellables)
    }
}
