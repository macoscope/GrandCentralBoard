//
//  TableViewDataSource.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 13/04/16.
//


import UIKit


protocol TableViewModel {
    associatedtype ItemViewModel: CellViewModel
    var items: [ItemViewModel] { get }
}


final class TableDataSource<T: CellConfiguring, U: TableViewModel where U.ItemViewModel == T.ViewModel> : NSObject, UITableViewDelegate, UITableViewDataSource {

    private var items: [T.ViewModel]?
    private let cellDequeuing: CellDequeuing
    private let cellConfiguring: T

    init(cellDequeuing: CellDequeuing, cellConfiguring: T) {
        self.cellConfiguring = cellConfiguring
        self.cellDequeuing = cellDequeuing
    }

    func configureWithViewModel(viewModel: U) {
        items = viewModel.items
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        guard let cell = cellDequeuing.dequeueCell() as? T.Cell else {
            fatalError("Cannot dequeue cell!")
        }

        guard let viewModel = items?[indexPath.row] else {
            fatalError("No view model!")
        }

        cellConfiguring.configureCell(cell, withViewModel: viewModel)
        
        return cell
    }
}
