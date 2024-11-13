//
//  GitHubRepositoriesViewModelTests.swift
//  GithubUsersTests
//
//  Created by mohamed tahoon on 12/11/2024.
//

import Foundation
import XCTest
import Combine
@testable import GithubUsers

class GitHubRepositoriesViewModelTests: XCTestCase {
    var viewModel: GitHubRepositoriesViewModel!
    var mockService: MockGitHubRepoService!
    var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        mockService = MockGitHubRepoService()
        viewModel = GitHubRepositoriesViewModel(repoService: mockService)
    }

    func testFetchRepositoriesSuccess() {
        let expectation = self.expectation(description: "Repositories should be fetched successfully")
        
        mockService.shouldFail = false
        
        viewModel.$repositories
            .dropFirst()
            .sink { repositories in
                if !repositories.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Call the function to fetch repositories
        viewModel.fetchRepositories(username: "testuser")
        
        // Wait for expectation to be fulfilled, with a timeout
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchRepositoriesFailure() {
        let expectation = self.expectation(description: "Error should be handled correctly")
        
        // Set up mock service to return failure
        mockService.shouldFail = true
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                if let errorMessage = errorMessage {
                    XCTAssertNotNil(errorMessage)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Call the function to fetch repositories
        viewModel.fetchRepositories(username: "testuser")
        
        // Wait for expectation to be fulfilled, with a timeout
        waitForExpectations(timeout: 5, handler: nil)
    }
}


class MockGitHubRepoService: GitHubRepoService {
    var shouldFail = false

    override func fetchRepositories(username: String) -> AnyPublisher<[GitHubRepoModel], Error> {
        if shouldFail {
            return Fail(error: NSError(domain: "GitHubError", code: 1, userInfo: nil))
                .eraseToAnyPublisher()
        } else {
            let repo = GitHubRepoModel(id: 123, name: "Test Repo", fullName: "test/test", description: "A test repo", license: nil, owner: nil, htmlUrl: "https://example.com", createdAt: "2024-11-12")
            return Just([repo])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
