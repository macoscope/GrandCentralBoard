//
//  WebsiteAnalyticsWidget.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 13/04/16.
//

import GCBCore


final class WebsiteAnalyticsWidget: WidgetControlling {
    private enum State {
        case Loading
        case Data(reports: [PageViewsRowReport])
        case NoData
        case Error
    }

    private let widgetView: TableWidgetView
    private let mainView: UIView

    private var state: State = .Loading {
        didSet {
            changeFromState(oldValue, toState: state)
        }
    }

    init(sources: [UpdatingSource]) {
        self.widgetView = TableWidgetView.fromNib()
        self.sources = sources

        let viewModel = WidgetTemplateViewModel(title: "BLOGPOSTS".localized.uppercaseString,
                                                subtitle: "MOST POPULAR".localized.uppercaseString,
                                                contentView: widgetView)
        let layoutSettings = WidgetTemplateLayoutSettings(contentMargin: UIEdgeInsets(top: -90, left: 0, bottom: 0, right: 0))
        let widgetViewWithHeader = WidgetTemplateView.viewWithViewModel(viewModel, layoutSettings: layoutSettings)

        mainView = UIView(frame: widgetViewWithHeader.frame)
        mainView.fillViewWithView(widgetViewWithHeader, animated: false)
    }


    // MARK: HavingSources

    let sources: [UpdatingSource]


    // MARK: WidgetControlling

    var view: UIView {
        return mainView
    }


    // MARK: Updateable

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
                    self?.state = reports.isEmpty ? .NoData : .Data(reports: reports)
                case .Failure:
                    self?.state = .Error
            }
        }
    }

    private func renderErrorView() {
        guard !mainView.subviews.contains(errorView) else { return }
        mainView.fillViewWithView(errorView, animated: false)
    }

    private func removeErrorView() {
        errorView.removeFromSuperview()
    }


    // MARK: State rendering

    private func changeFromState(fromState: State, toState: State) {
        switch toState {
            case .Error:
                guard !mainView.subviews.contains(errorView) else { return }
                mainView.fillViewWithView(errorView, animated: false)
            case .NoData:
                guard !mainView.subviews.contains(noDataView) else { return }
                mainView.fillViewWithView(noDataView, animated: false)
            case .Data(let reports):
                [errorView, noDataView].forEach { $0.removeFromSuperview() }
                updateWithReports(reports)
            default:
                break
        }
    }

    private func updateWithReports(reports: [PageViewsRowReport]) {
        let reportsSlice = reports[0...min(3, reports.count)]
        let viewModel = reportsSlice.flatMap({ report -> DoubleColumnCellViewModel? in
            guard !report.pageTitle.isEmpty else { return nil }
            return DoubleColumnCellViewModel(title: report.pageTitle, valueDescription: "\(report.visits)")
        })

        widgetView.setRowViewModels(viewModel)
    }

    private lazy var errorView: UIView = {
        let viewModel = WidgetErrorTemplateViewModel(title: "BLOGPOSTS".localized.uppercaseString,
                                                     subtitle: "Error".localized.uppercaseString)
        return WidgetTemplateView.viewWithErrorViewModel(viewModel)
    }()

    private lazy var noDataView: UIView = {
        let viewModel = WidgetErrorTemplateViewModel(title: "BLOGPOSTS".localized.uppercaseString,
                                                     subtitle: "NO DATA".localized)
        return WidgetTemplateView.viewWithErrorViewModel(viewModel)
    }()
}
