//
//  WebsiteAnalyticsWidget.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 13/04/16.
//

import GCBCore


final class WebsiteAnalyticsWidget: WidgetControlling {

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
        case let source as PageViewsSource:
            fetchAnalyticsFromSource(source)
        default:
            assertionFailure("Expected `source` as instance of `GoogleAnalyticsSource`.")
        }
    }

    private func fetchAnalyticsFromSource(source: PageViewsSource) {
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
        let reportsSlice = reports[0...min(3, reports.count)]
        let viewModel = reportsSlice.flatMap({ report -> DoubleColumnCellViewModel? in
            if report.pageTitle.isEmpty { return nil }
            return DoubleColumnCellViewModel(title: report.pageTitle, valueDescription: "\(report.visits)")
        })

        widgetView.setRowViewModels(viewModel)
    }
}
