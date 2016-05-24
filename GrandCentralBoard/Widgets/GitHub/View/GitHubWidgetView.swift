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

    override func layoutSubviews() {
        super.layoutSubviews()
        rowHeight = 116
        layoutMargins = UIEdgeInsetsZero
        maskView = nil
        tableDataSource.setUpTableView(self)
    }

    func configureWithViewModel(viewModel: GitHubWidgetViewModel) {
        tableDataSource.items = viewModel.cellItems
        reloadData()
    }
}
