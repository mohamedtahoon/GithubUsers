//
//  UsersViewModelTests.swift
//  GithubUsersTests
//
//  Created by mohamed tahoon on 12/11/2024.
//

import XCTest
import Combine
@testable import GithubUsers


class GitHubUsersViewModelTests: XCTestCase {
    
    var viewModel: GitHubUsersViewModel!
    var mockUserService: MockGitHubUserService!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        
        // Create the mock service and inject it into the view model
        mockUserService = MockGitHubUserService()
        viewModel = GitHubUsersViewModel(userService: mockUserService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockUserService = nil
        cancellables = []
        super.tearDown()
    }
    
    func testFetchUsers_Success() {
        // Arrange
        let mockUsers = [
            GitHubUsersModel(
                id: 1,
                login: "john",
                avatar_url: "https://avatars.githubusercontent.com/u/1?v=4",
                url: "https://api.github.com/users/john",
                html_url: "https://github.com/john",
                followers_url: "https://api.github.com/users/john/followers",
                following_url: "https://api.github.com/users/john/following{/other_user}",
                gists_url: "https://api.github.com/users/john/gists{/gist_id}",
                starred_url: "https://api.github.com/users/john/starred{/owner}{/repo}",
                subscriptions_url: "https://api.github.com/users/john/subscriptions",
                organizations_url: "https://api.github.com/users/john/orgs",
                repos_url: "https://api.github.com/users/john/repos",
                events_url: "https://api.github.com/users/john/events{/privacy}",
                received_events_url: "https://api.github.com/users/john/received_events",
                type: "User",
                site_admin: false,
                followersCount: 100,
                reposCount: 30
            )
        ]

        mockUserService.mockUsers = mockUsers
        
        let expectation = self.expectation(description: "Users fetched successfully")
        
        // Act
        viewModel.fetchUsers()
        
        // Assert
        viewModel.$users
            .dropFirst() // Ignore initial empty state
            .sink(receiveValue: { users in
                XCTAssertEqual(users.count, mockUsers.count, "Expected number of users to match")
                XCTAssertEqual(users.first?.login, mockUsers.first?.login, "Expected first user's login to match")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 4)
    }
    
    func testFetchUsers_Failure() {
        // Arrange: simulate an error from the service
        mockUserService.shouldFail = true
        
        let expectation = self.expectation(description: "Error handling in failure case")
        
        // Act
        viewModel.fetchUsers()
        
        // Assert
        viewModel.$errorMessage
            .dropFirst() // Ignore initial state
            .sink(receiveValue: { error in
                XCTAssertNotNil(error, "Expected error message to be set")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 4)
    }
}

//MARK: Mock GitHubUserService
class MockGitHubUserService: GitHubUserService {
    
    var mockUsers: [GitHubUsersModel] = []
    var shouldFail = false
    
    override func fetchUsers() -> AnyPublisher<[GitHubUsersModel], Error> {
        if shouldFail {
            return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
        }
        return Just(mockUsers)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    override func fetchFullUserDetails(for user: GitHubUsersModel) -> AnyPublisher<GitHubUsersModel, Error> {
        return Just(user)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
