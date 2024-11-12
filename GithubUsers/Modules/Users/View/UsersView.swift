//
//  ContentView.swift
//  GithubUsers
//
//  Created by mohamed tahoon on 10/11/2024.
//

import SwiftUI

struct UsersView: View {
    @StateObject private var viewModel = GitHubUsersViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else {
                    UserListView(users: viewModel.users)
                }
            }
            .navigationTitle("GitHub Users")
            .onAppear {
                viewModel.fetchUsers()
            }
            .alert(item: $viewModel.errorMessage) { errorMessage in
                Alert(title: Text("Error"), message: Text(errorMessage.message), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct UserListView: View {
    let users: [GitHubUsersModel]
    
    var body: some View {
        List(users) { user in
            NavigationLink(destination: RepositoriesViewControllerWrapper(username: user.login)) {
                UserRow(user: user)
            }
        }
    }
}

struct UserRow: View {
    let user: GitHubUsersModel
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: user.avatar_url))
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(user.login)
                    .font(.headline)
                
                if let followersCount = user.followersCount {
                    Text("Followers: \(followersCount)")
                        .font(.subheadline)
                }
                if let reposCount = user.reposCount {
                    Text("Repositories: \(reposCount)")
                        .font(.subheadline)
                }
            }
        }
    }
}



struct RepositoriesViewControllerWrapper: UIViewControllerRepresentable {
    let username: String
    
    func makeUIViewController(context: Context) -> RepositoriesViewController {
        let viewController = RepositoriesViewController()
        viewController.username = username
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: RepositoriesViewController, context: Context) {}
}
