//
//  TableViewCell.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 14/04/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit


class TableViewCell: UITableViewCell, ConfigurableWithViewModel {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueDescriptionLabel: UILabel!

    static func nib() -> UINib {
        return UINib.init(nibName: "TableViewCell", bundle: nil)
    }

    func configureWithViewModel(viewModel: DoubleColumnCellViewModel) {
        self.titleLabel.text = viewModel.title
        self.valueDescriptionLabel.text = viewModel.valueDescription
    }

}
