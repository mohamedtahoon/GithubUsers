//
//  NetworkManagerTests.swift
//  GithubUsersTests
//
//  Created by mohamed tahoon on 12/11/2024.
//

import Foundation
import Combine
import XCTest
@testable import GithubUsers

class NetworkManagerTests: XCTestCase {
    
    var networkManager: NetworkManager!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        networkManager = NetworkManager.shared
    }
    
    override func tearDown() {
        networkManager = nil
        super.tearDown()
    }
    
    func testFetchData_Success() {
        let url = URL(string: "https://api.github.com/users")!
        
        let expectation = self.expectation(description: "Data fetched successfully")
        
        networkManager.fetchData(from: url, type: [GitHubUsersModel].self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTFail("Expected success, but received error: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { users in
                XCTAssertTrue(users.count > 0, "Expected users to be returned")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchData_Failure() {
        // Test for a failure response, such as a 404 error
        let url = URL(string: "https://api.github.com/notExistentEndpoint")!
        
        let expectation = self.expectation(description: "Data fetch failure")
        
        networkManager.fetchData(from: url, type: [GitHubUsersModel].self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTAssertNotNil(error, "Expected error, but received success")
                    expectation.fulfill()
                case .finished:
                    break
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, but received data")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
