//
//  TableView.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 14/04/16.
//

import UIKit


struct DoubleColumnHeaderViewModel: HeaderViewModel {
    let firstColumnName: String
    let secondColumnName: String
    let height: CGFloat = 4
}


struct DoubleColumnCellViewModel: CellViewModel {
    let title: String
    let valueDescription: String
}


struct DoubleColumnTableViewModel: TableViewModel {
    let firstColumnName: String
    let secondColumnName: String
    let items: [DoubleColumnCellViewModel]
    let headerViewModel: DoubleColumnHeaderViewModel
}



final class TableWidgetView: UIView {

    @IBOutlet weak var tableView: UITableView!
    private var dataSource: TableDataSource<CellConfigurator<TableViewCell, DoubleColumnCellViewModel, TableViewHeaderView, DoubleColumnHeaderViewModel>, DoubleColumnTableViewModel>?

    override func awakeFromNib() {
        super.awakeFromNib()

        let viewReuseController = ViewReuseController(cellNib: TableViewCell.nib(), cellIdentifier: "TableViewCell", headerNib: TableViewHeaderView.nib(), headerIdentifier: "TableViewHeaderView", tableView: tableView)
        let viewConfigurator = CellConfigurator<TableViewCell, DoubleColumnCellViewModel, TableViewHeaderView, DoubleColumnHeaderViewModel>()

        let headerViewModel = DoubleColumnHeaderViewModel(firstColumnName: "Title", secondColumnName: "Visits")
        let viewModel = DoubleColumnTableViewModel(firstColumnName: "Title", secondColumnName: "Visits", items: [DoubleColumnCellViewModel(title: "test2 test2 test2 test2 test2 test2 test2 test2 test2 test2 test2 test2", valueDescription: "123"), DoubleColumnCellViewModel(title: "test2 test2 test2 test2 test2 test2 test2 test2 test2 test2 test2 test2", valueDescription: "101"), DoubleColumnCellViewModel(title: "test2 test2 test2 test2 test2 test2 test2 test2 test2 test2 test2 test2 ", valueDescription: "89")], headerViewModel: headerViewModel)

        dataSource = TableDataSource(viewDequeuing: viewReuseController, viewConfiguring: viewConfigurator,viewModel: viewModel)
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.estimatedRowHeight = 100
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    class func fromNib() -> TableWidgetView {
        return NSBundle.mainBundle().loadNibNamed("TableWidgetView", owner: nil, options: nil)[0] as! TableWidgetView
    }
    
}
