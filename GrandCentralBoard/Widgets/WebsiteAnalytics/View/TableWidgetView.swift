//
//  TableView.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 14/04/16.
//

import UIKit


final class TableWidgetView: UIView {

    @IBOutlet weak var tableView: UITableView!

    class func fromNib() -> TableWidgetView {
        return NSBundle.mainBundle().loadNibNamed("TableWidgetView", owner: nil, options: nil)[0] as! TableWidgetView
    }
    
}
