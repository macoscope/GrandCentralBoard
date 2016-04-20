//
//  Cell.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 13/04/16.
//

import UIKit


protocol ViewDequeuing {
    func dequeueCell() -> UITableViewCell?
    func dequeueHeader() -> UIView?
}


final class ViewReuseController: ViewDequeuing {
    private let cellNib: UINib
    private let cellIdentifier: String
    private let headerNib: UINib
    private let headerIdentifier: String
    private weak var tableView: UITableView?

    init(cellNib: UINib, cellIdentifier: String, headerNib: UINib, headerIdentifier: String, tableView: UITableView) {
        self.cellNib = cellNib
        self.cellIdentifier = cellIdentifier
        self.headerNib = headerNib
        self.headerIdentifier = headerIdentifier
        self.tableView = tableView

        tableView.registerNib(cellNib, forCellReuseIdentifier: cellIdentifier)
        tableView.registerNib(headerNib, forHeaderFooterViewReuseIdentifier: headerIdentifier)
    }

    func dequeueCell() -> UITableViewCell? {
        return tableView?.dequeueReusableCellWithIdentifier(cellIdentifier)
    }

    func dequeueHeader() -> UIView? {
        return tableView?.dequeueReusableHeaderFooterViewWithIdentifier(headerIdentifier)
    }
}

protocol CellViewModel {

}

protocol HeaderViewModel {
    var height: CGFloat { get }
}

protocol CellConfigurableWithViewModel {
    associatedtype ViewModel
    func configureWithViewModel(viewModel: ViewModel)
}


protocol ViewConfiguring {
    associatedtype Cell: UITableViewCell
    associatedtype CellViewModel: GrandCentralBoard.CellViewModel

    associatedtype HeaderViewModel: GrandCentralBoard.HeaderViewModel
    associatedtype Header: UITableViewHeaderFooterView

    func configureCell(cell: Cell, withViewModel viewModel: CellViewModel)
    func configureHeader(header: Header, withViewModel viewModel: HeaderViewModel)
}


final class CellConfigurator<
    Cell: CellConfigurableWithViewModel,
    CellViewModel: GrandCentralBoard.CellViewModel,
    Header: HeaderConfigurableWithViewModel,
    HeaderViewModel: GrandCentralBoard.HeaderViewModel
    where
    Cell: UITableViewCell,
    Cell.ViewModel == CellViewModel,
    Header: UITableViewHeaderFooterView,
    Header.ViewModel == HeaderViewModel
> : ViewConfiguring {

    func configureCell(cell: Cell, withViewModel viewModel: CellViewModel) {
        cell.configureWithViewModel(viewModel)
    }

    func configureHeader(header: Header, withViewModel viewModel: HeaderViewModel) {
        header.configureWithViewModel(viewModel)
    }
}

protocol HeaderConfigurableWithViewModel {
    associatedtype ViewModel
    func configureWithViewModel(viewModel: ViewModel)
}
