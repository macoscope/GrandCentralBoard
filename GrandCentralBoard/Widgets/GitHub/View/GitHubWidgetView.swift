//
//  GitHubWidgetView.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 22/05/16.
//  Copyright © 2016 Michał Laskowski. All rights reserved.
//

import UIKit


struct GitHubWidgetViewModel {
    let cellItems: [GitHubCellViewModel]
}

final class GitHubWidgetView: UITableView {

    private let tableDataSource = GitHubTableDataSource()

    override func layoutSubviews() {
        super.layoutSubviews()
        dataSource = tableDataSource
    }

    func configureWithViewModel(viewModel: GitHubWidgetViewModel) {
        tableDataSource.items = viewModel.cellItems
        reloadData()
    }
}
