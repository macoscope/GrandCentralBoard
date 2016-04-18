//
//  TableViewHeaderView.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 14/04/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit


class TableViewHeaderView: UITableViewHeaderFooterView, HeaderConfigurableWithViewModel {
    @IBOutlet weak var firstColumnTitleLabel: UILabel!
    @IBOutlet weak var secondColumnTitleLabel: UILabel!

    func configureWithViewModel(viewModel: DoubleColumnHeaderViewModel) {
        self.firstColumnTitleLabel.text = viewModel.firstColumnName.uppercaseString
        self.secondColumnTitleLabel.text = viewModel.secondColumnName.uppercaseString
    }

    static func nib() -> UINib {
        return UINib.init(nibName: "TableViewHeaderView", bundle: nil)
    }
}
