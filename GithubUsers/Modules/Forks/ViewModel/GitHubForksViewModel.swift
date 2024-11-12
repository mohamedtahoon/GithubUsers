//
//  GitHubForksViewModel.swift
//  GithubUsers
//
//  Created by mohamed tahoon on 11/11/2024.
//

import Foundation
import Combine
import SwiftUI

class GitHubForksViewModel: ObservableObject {
    @Published var forks: [GitHubForksModel] = []
    @Published var isLoading = false
    @Published var errorMessage: IdentifiableError?
    
    private let forkService = GitHubForkService()
    private var cancellable: AnyCancellable?
    
    func fetchForks(owner: String, repo: String) {
        isLoading = true
        
        // Cancel any existing fetch operation
        cancellable?.cancel()
        cancellable = forkService.fetchForks(owner: owner, repo: repo)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = IdentifiableError(message: error.localizedDescription)
                }
            }, receiveValue: { forks in
                self.forks = forks
            })
    }
}
