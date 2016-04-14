//
//  Cell.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 13/04/16.
//

import UIKit


protocol CellDequeuing {
    func dequeueCell() -> UITableViewCell?
}


final class CellReuseController : CellDequeuing {
    private let nib: UINib
    private let identifier: String
    private weak var tableView: UITableView?

    init(nib: UINib, identifier: String, tableView: UITableView) {
        self.nib = nib
        self.identifier = identifier
        self.tableView = tableView

        tableView.registerNib(nib, forCellReuseIdentifier: identifier)
    }

    func dequeueCell() -> UITableViewCell? {
        return tableView?.dequeueReusableCellWithIdentifier(identifier)
    }
}


protocol CellViewModel {

}


protocol ConfigurableWithViewModel {
    associatedtype ViewModel
    func configureWithViewModel(viewModel: ViewModel)
}


protocol CellConfiguring {
    associatedtype Cell: UITableViewCell
    associatedtype ViewModel: CellViewModel

    func configureCell(cell: Cell, withViewModel viewModel: ViewModel)
}


final class CellConfigurator<Cell: ConfigurableWithViewModel, ViewModel: CellViewModel where Cell: UITableViewCell, Cell.ViewModel == ViewModel> : CellConfiguring {
    func configureCell(cell: Cell, withViewModel viewModel: ViewModel) {
        cell.configureWithViewModel(viewModel)
    }
}