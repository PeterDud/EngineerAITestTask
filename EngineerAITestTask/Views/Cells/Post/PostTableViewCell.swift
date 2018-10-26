//
//  PostTableViewCell.swift
//  EngineerAITestTask
//
//  Created by Peter Dudar  on 26/10/2018.
//  Copyright © 2018 CHI. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    static let identifier = "PostTableViewCell"
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    // MARK: - Setup
    func setupWith(model: Post) {
        titleLabel.text = model.title
        dateLabel.text = model.createdAt
    }
}
