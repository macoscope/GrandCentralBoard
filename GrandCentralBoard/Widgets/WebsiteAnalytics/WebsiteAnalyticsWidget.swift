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
        switch source {
        case let source as GoogleAnalyticsSource:
            fetchAnalyticsFromSource(source)
        default:
            assertionFailure("Expected `source` as instance of `GoogleAnalyticsSource`.")
        }
    }

    private func fetchAnalyticsFromSource(source: GoogleAnalyticsSource) {
        source.read { [weak self] result in
            switch result {
            case .Success(let reports):
                self?.updateWithReports(reports)
            case .Failure:
                break
            }
        }
    }

    private func updateWithReports(reports: [PageViewsRowReport]) {
        let viewModel = reports.map( {
            DoubleColumnCellViewModel(title: $0.pagePath, valueDescription: "\($0.visits)")
        })
        widgetView.setRowViewModels(viewModel)
    }
}
