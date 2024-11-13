//
//  NetworkManager.swift
//  GithubUsers
//
//  Created by mohamed tahoon on 11/11/2024.
//

import Foundation
import Combine

// MARK: - NetworkManager
class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    //MARK: This token because i reached the free limit for hiting the apis, so i hade to use token to continue testing.
    private let defaultToken = "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"
    
    func fetchData<T: Codable>(
        from url: URL,
        type: T.Type,
        token: String? = nil,
        additionalHeaders: [String: String] = [:]
    ) -> AnyPublisher<T, Error> {
        var request = URLRequest(url: url)
        
        let authorizationToken = token?.isEmpty == false ? token! : defaultToken
        request.setValue("Bearer \(authorizationToken)", forHTTPHeaderField: "Authorization")
        
        additionalHeaders.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                // Handle server errors
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.badResponse
                }
                
                if !(200...299).contains(httpResponse.statusCode) {
                    throw NetworkError.httpError(statusCode: httpResponse.statusCode)
                }
                
                // Log the response in debug mode
            #if DEBUG
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) {
                    print("JSON Response: \(jsonObject)")
                }
            #endif
                
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                NetworkError.mapError(error)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
