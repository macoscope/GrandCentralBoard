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
    private var dataSource: TableDataSource<
    CellConfigurator<TableViewCell, DoubleColumnCellViewModel, TableViewHeaderView, DoubleColumnHeaderViewModel>,
    DoubleColumnTableViewModel>?

    private let headerViewModel = DoubleColumnHeaderViewModel(firstColumnName: "Title", secondColumnName: "Visits")

    func setRowViewModels(rowViewModels: [DoubleColumnCellViewModel]) {
        dataSource?.viewModel = DoubleColumnTableViewModel(firstColumnName: "Title", secondColumnName: "Visits",
                                                           items: rowViewModels, headerViewModel: headerViewModel)
        tableView.reloadData()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        let viewReuseController = ViewReuseController(cellNib: TableViewCell.nib(), cellIdentifier: "TableViewCell",
                                                      headerNib: TableViewHeaderView.nib(), headerIdentifier: "TableViewHeaderView",
                                                      tableView: tableView)
        let viewConfigurator = CellConfigurator<TableViewCell, DoubleColumnCellViewModel, TableViewHeaderView, DoubleColumnHeaderViewModel>()

        let viewModel = DoubleColumnTableViewModel(firstColumnName: "Title", secondColumnName: "Visits", items: [], headerViewModel: headerViewModel)

        dataSource = TableDataSource(viewDequeuing: viewReuseController, viewConfiguring: viewConfigurator, viewModel: viewModel)
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
