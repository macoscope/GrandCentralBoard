//
//  GitHubWidgetView.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 22/05/16.
//

import UIKit


struct GitHubWidgetViewModel {
    let cellItems: [GitHubCellViewModel]
}

final class GitHubWidgetView: UITableView {

    private let tableDataSource = GitHubTableDataSource()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setUp()
    }

    private func setUp() {
        rowHeight = 116
        layoutMargins = UIEdgeInsetsZero
        maskView = nil
        allowsSelection = false
        tableDataSource.setUpTableView(self)
    }

    func configureWithViewModel(viewModel: GitHubWidgetViewModel) {
        tableDataSource.items = viewModel.cellItems
        reloadData()
    }
}
