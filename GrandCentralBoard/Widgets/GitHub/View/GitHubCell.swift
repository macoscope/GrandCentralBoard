//
//  GitHubCell.swift
//  GrandCentralBoard
//
//  Created by mlaskowski on 21/05/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit


struct GitHubCellViewModel {
    let countLabelText: String
    let nameLabelText: String
    let color: UIColor
}

final class GitHubCell: UITableViewCell {

    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var circleView: EllipseView!

    func configureWithViewModel(viewModel: GitHubCellViewModel) {
        countLabel.textColor = viewModel.color
        countLabel.text = viewModel.countLabelText

        nameLabel.text = viewModel.nameLabelText

        circleView.color = viewModel.color
    }
}