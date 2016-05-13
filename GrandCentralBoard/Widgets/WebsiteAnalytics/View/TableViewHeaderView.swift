//
//  TableViewHeaderView.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 14/04/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import GCBUtilities


class TableViewHeaderView: UITableViewHeaderFooterView, HeaderConfigurableWithViewModel {
    @IBOutlet weak var firstColumnTitleLabel: GCBUtilities.LabelWithSpacing!
    @IBOutlet weak var secondColumnTitleLabel: GCBUtilities.LabelWithSpacing!

    func configureWithViewModel(viewModel: DoubleColumnHeaderViewModel) {
        firstColumnTitleLabel.text = viewModel.firstColumnName.uppercaseString
        firstColumnTitleLabel.applyCustomAttributes()
        secondColumnTitleLabel.text = viewModel.secondColumnName.uppercaseString
        secondColumnTitleLabel.applyCustomAttributes()
    }

    static func nib() -> UINib {
        return UINib.init(nibName: "TableViewHeaderView", bundle: nil)
    }
}
