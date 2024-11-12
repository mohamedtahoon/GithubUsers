//
//  RepositoriesView.swift
//  GithubUsers
//
//  Created by mohamed tahoon on 11/11/2024.
//

import UIKit
import Combine

class RepositoriesViewController: UIViewController {
    
    private var tableView: UITableView!
    private var loadingIndicator: UIActivityIndicatorView!
    private var viewModel = GitHubRepositoriesViewModel()
    private var cancellables = Set<AnyCancellable>()
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let username = username else {
            showErrorAlert(message: "Username is missing")
            return
        }
        
        title = "\(username)'s Repos"
        setupTableView()
        setupLoadingIndicator()
        bindViewModel()
        viewModel.fetchRepositories(username: username)
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RepoTableViewCell", bundle: nil), forCellReuseIdentifier: "RepoTableViewCell")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.$repositories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                isLoading ? self?.loadingIndicator.startAnimating() : self?.loadingIndicator.stopAnimating()
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    self?.showErrorAlert(message: errorMessage.message)
                }
            }
            .store(in: &cancellables)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension RepositoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepoTableViewCell", for: indexPath) as? RepoTableViewCell else {
            return UITableViewCell()
        }
        let repo = viewModel.repositories[indexPath.row]
        cell.configure(repo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRepo = viewModel.repositories[indexPath.row]
        
        let forksView = ForksView()
        forksView.owner = username
        forksView.repo = selectedRepo.name
        
        navigationController?.pushViewController(forksView, animated: true)
    }
}
