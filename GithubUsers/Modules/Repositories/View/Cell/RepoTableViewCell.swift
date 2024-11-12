//
//  RepoTableViewCell.swift
//  GithubUsers
//
//  Created by mohamed tahoon on 12/11/2024.
//

import Foundation
import UIKit

class RepoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionsLabel: UILabel!
    @IBOutlet weak var licensesLabel: UILabel!
    
    func configure(_ repo: GitHubRepoModel) {
        nameLabel.text = repo.name
        descriptionsLabel.text = repo.description
        if let licenses = repo.license {
            licensesLabel.text = licenses.name
        } else {
            licensesLabel.text = "No license"
        }
    }
}
