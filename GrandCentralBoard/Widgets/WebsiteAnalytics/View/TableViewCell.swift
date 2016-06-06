//
//  TableViewCell.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 14/04/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit


class TableViewCell: UITableViewCell, CellConfigurableWithViewModel {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueDescriptionLabel: UILabel!

    private lazy var titleParagraphStyle: NSParagraphStyle = { [unowned self] in
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 34.0 / self.titleLabel.font.lineHeight
        return style
    }()

    private lazy var valueParagraphStyle: NSParagraphStyle = { [unowned self] in
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1
        return style
    }()

    static func nib() -> UINib {
        return UINib.init(nibName: "TableViewCell", bundle: nil)
    }

    func configureWithViewModel(viewModel: DoubleColumnCellViewModel) {
        self.titleLabel.attributedText = NSAttributedString(string: viewModel.title,
                                                            attributes: [NSParagraphStyleAttributeName: titleParagraphStyle])
        self.valueDescriptionLabel.attributedText = NSAttributedString(string: viewModel.valueDescription,
                                                                       attributes: [NSParagraphStyleAttributeName: valueParagraphStyle])
    }

}
