//
//  WebsiteAnalyticsWidget.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 13/04/16.
//

import GrandCentralBoardCore


final class WebsiteAnalyticsWidget: Widget {

    private let widgetView: TableWidgetView
    let sources: [UpdatingSource]

    var view: UIView {
        get {
            return widgetView
        }
    }

    init(sources: [UpdatingSource]) {
        self.widgetView = TableWidgetView.fromNib()
        self.sources = sources
    }

    func update(source: UpdatingSource) {
        
    }

}
