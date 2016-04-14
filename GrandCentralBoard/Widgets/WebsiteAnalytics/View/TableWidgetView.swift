//
//  TableView.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 14/04/16.
//

import UIKit


struct DoubleColumnCellViewModel: CellViewModel {
    let title: String
    let valueDescription: String
}


struct DoubleColumnTableViewModel: TableViewModel {
    let firstColumnName: String
    let secondColumnName: String
    let items: [DoubleColumnCellViewModel]
}


final class TableWidgetView: UIView {

    @IBOutlet weak var tableView: UITableView!
    private var dataSource: TableDataSource<CellConfigurator<TableViewCell, DoubleColumnCellViewModel>, DoubleColumnTableViewModel>?

    override func awakeFromNib() {
        super.awakeFromNib()

        let cellReuseController = CellReuseController(nib: TableViewCell.nib(), identifier: "TableViewCell", tableView: tableView)
        let cellConfigurator = CellConfigurator<TableViewCell, DoubleColumnCellViewModel>()

        let viewModel = DoubleColumnTableViewModel(firstColumnName: "Title", secondColumnName: "Visits", items: [DoubleColumnCellViewModel(title: "test2 test2 test2 test2 test2 test2 test2 test2 test2 test2 test2 test2", valueDescription: "123"), DoubleColumnCellViewModel(title: "test2 test2 test2 test2 test2 test2 test2 test2 test2 test2 test2 test2", valueDescription: "101"), DoubleColumnCellViewModel(title: "test2 test2 test2 test2 test2 test2 test2 test2 test2 test2 test2 test2 ", valueDescription: "89")])

        dataSource = TableDataSource(cellDequeuing: cellReuseController, cellConfiguring: cellConfigurator, viewModel: viewModel)
        tableView.dataSource = dataSource
        tableView.estimatedRowHeight = 100
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    class func fromNib() -> TableWidgetView {
        return NSBundle.mainBundle().loadNibNamed("TableWidgetView", owner: nil, options: nil)[0] as! TableWidgetView
    }
    
}
