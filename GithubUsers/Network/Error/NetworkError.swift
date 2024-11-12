//
//  NetworkError.swift
//  GithubUsers
//
//  Created by mohamed tahoon on 12/11/2024.
//

import Foundation

enum NetworkError: Error {
    case badResponse
    case httpError(statusCode: Int)
    case decodingError
    case customError(message: String)
    
    static func mapError(_ error: Error) -> NetworkError {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                return .customError(message: "No internet connection")
            case .timedOut:
                return .customError(message: "Request timed out")
            default:
                return .customError(message: urlError.localizedDescription)
            }
        } else if error is DecodingError {
            return .decodingError
        }
        return .customError(message: error.localizedDescription)
    }
}
