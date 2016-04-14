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

    private var viewModel: U
    private let cellDequeuing: CellDequeuing
    private let cellConfiguring: T

    init(cellDequeuing: CellDequeuing, cellConfiguring: T, viewModel: U) {
        self.cellConfiguring = cellConfiguring
        self.cellDequeuing = cellDequeuing
        self.viewModel = viewModel
    }

    func configureWithViewModel(viewModel: U) {
        self.viewModel = viewModel
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        guard let cell = cellDequeuing.dequeueCell() as? T.Cell else {
            fatalError("Cannot dequeue cell!")
        }

        let viewModel = self.viewModel.items[indexPath.row]
        cellConfiguring.configureCell(cell, withViewModel: viewModel)
        
        return cell
    }
}
