//
//  GitHubCell.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 21/05/16.
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
        case 0 ..< 4: return UIColor(red: 246/255, green: 157/255, blue: 67/255, alpha: 1)
        default: return UIColor(red: 206/255, green: 18/255, blue: 37/255, alpha: 1)
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
