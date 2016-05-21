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

extension GitHubCellViewModel {

    init?(forRepository repo: Repository) {
        guard let prCount = repo.pullRequestsCount else {
            return nil
        }

        countLabelText = "\(prCount)"
        nameLabelText = repo.name.uppercaseString
        color = UIColor.colorForPRCount(prCount)
    }
}

private extension UIColor {
    class func colorForPRCount(count: Int) -> UIColor {
        switch count {
        case 0 ..< 4: return UIColor.gcb_greenColor()
        case 4 ..< 8: return UIColor.gcb_fadedOrangeColor()
        default: return UIColor.gcb_redColor()
        }
    }
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

    class func fromNib() -> GitHubCell {
        return NSBundle.mainBundle().loadNibNamed("GitHubCell", owner: nil, options: nil)[0] as! GitHubCell
    }
}
