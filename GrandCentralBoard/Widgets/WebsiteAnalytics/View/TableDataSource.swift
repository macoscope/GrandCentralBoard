//
//  TableViewDataSource.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 13/04/16.
//


import UIKit


protocol TableViewModel {
    associatedtype CellViewModel: GrandCentralBoard.CellViewModel
    associatedtype HeaderViewModel: GrandCentralBoard.HeaderViewModel
    var items: [CellViewModel] { get }
    var headerViewModel: HeaderViewModel { get }
}


final class TableDataSource<T: ViewConfiguring, U: TableViewModel where U.CellViewModel == T.CellViewModel, U.HeaderViewModel == T.HeaderViewModel> : NSObject, UITableViewDelegate, UITableViewDataSource {

    var viewModel: U
    private let viewConfiguring: T
    private let viewDequeuing: ViewDequeuing

    init(viewDequeuing: ViewDequeuing, viewConfiguring: T, viewModel: U) {
        self.viewConfiguring = viewConfiguring
        self.viewDequeuing = viewDequeuing
        self.viewModel = viewModel
    }

    func configureWithViewModel(viewModel: U) {
        self.viewModel = viewModel
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        guard let cell = viewDequeuing.dequeueCell() as? T.Cell else {
            fatalError("Cannot dequeue cell!")
        }

        let viewModel = self.viewModel.items[indexPath.row]
        viewConfiguring.configureCell(cell, withViewModel: viewModel)
        
        return cell
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.viewModel.headerViewModel.height
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = viewDequeuing.dequeueHeader() as? T.Header else {
            fatalError("Cannot dequeue header!")
        }

        viewConfiguring.configureHeader(headerView, withViewModel: self.viewModel.headerViewModel)
        
        return headerView
    }

}
