//
//  TableView.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 14/04/16.
//

import UIKit


struct EmptyHeaderViewModel: HeaderViewModel {
    let height: CGFloat = 0
}


struct DoubleColumnCellViewModel: CellViewModel {
    let title: String
    let valueDescription: String
}


struct DoubleColumnTableViewModel: TableViewModel {
    let items: [DoubleColumnCellViewModel]
    let headerViewModel: EmptyHeaderViewModel
}



final class TableWidgetView: UIView {

    @IBOutlet weak var tableView: UITableView!
    private var dataSource: TableDataSource<
    CellConfigurator<TableViewCell, DoubleColumnCellViewModel, EmptyHeaderView, EmptyHeaderViewModel>,
    DoubleColumnTableViewModel>?

    private let headerViewModel = EmptyHeaderViewModel()

    func setRowViewModels(rowViewModels: [DoubleColumnCellViewModel]) {
        dataSource?.viewModel = DoubleColumnTableViewModel(items: rowViewModels, headerViewModel: headerViewModel)
        tableView.reloadData()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        let viewReuseController = ViewReuseController(cellNib: TableViewCell.nib(), cellIdentifier: "TableViewCell",
                                                      headerNib: nil, headerIdentifier: nil,
                                                      tableView: tableView)
        let viewConfigurator = CellConfigurator<TableViewCell, DoubleColumnCellViewModel, EmptyHeaderView, EmptyHeaderViewModel>()

        let viewModel = DoubleColumnTableViewModel(items: [], headerViewModel: headerViewModel)

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
