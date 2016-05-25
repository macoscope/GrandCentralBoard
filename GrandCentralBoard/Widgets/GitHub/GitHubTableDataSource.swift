//
//  GitHubTableDataSource.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 21/05/16.
//

import UIKit


class GitHubTableDataSource: NSObject, UITableViewDataSource {

    private let maxRowsToShow = 3
    private let cellID = "cell"
    var items: [GitHubCellViewModel] = []

    func setUpTableView(tableView: UITableView) {
        tableView.registerNib(UINib(nibName: "GitHubCell", bundle: nil), forCellReuseIdentifier: cellID)
        tableView.dataSource = self
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(maxRowsToShow, items.count)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! GitHubCell
        cell.configureWithViewModel(items[indexPath.row])
        return cell
    }
}
