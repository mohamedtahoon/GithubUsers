//
//  IdentifiableError.swift
//  GithubUsers
//
//  Created by mohamed tahoon on 12/11/2024.
//

import Foundation

struct IdentifiableError: Identifiable {
    let id = UUID()
    let message: String
}
