//
//  ForkCell.swift
//  GithubUsers
//
//  Created by mohamed tahoon on 12/11/2024.
//

import Foundation
import SwiftUI

struct ForkCell: View {
    let fork: GitHubForksModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(fork.name)
                .font(.headline)
            Text(fork.description)
                .font(.subheadline)
            Text(fork.full_name)
                .font(.subheadline)
        }
        .padding()
    }
}
