//
//  GitHubWidget.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 21/05/16.
//

import GCBCore
import GCBUtilities


private let widgetTitle = "GitHub".uppercaseString
private let widgetSubtitle = "Pull Requests".uppercaseString

final class GitHubWidget: WidgetControlling {

    let sources: [UpdatingSource]

    private let widgetView = GitHubWidgetView()
    private let templatedWidgetView: UIView

    private lazy var errorView: UIView = {
        let errorViewModel = WidgetErrorTemplateViewModel(title: widgetTitle, subtitle: "Error".localized.uppercaseString)
        return WidgetTemplateView.viewWithErrorViewModel(errorViewModel)
    }()

    private lazy var noOpenPullRequestsView: UIView = {
        let view = NSBundle.mainBundle().loadNibNamed("NoOpenPRPlaceholder", owner: nil, options: nil)[0] as! UIView
        let viewModel = WidgetTemplateViewModel(title: widgetTitle, subtitle: widgetSubtitle, contentView: view)
        let layoutSettings = WidgetTemplateLayoutSettings(contentMargin: UIEdgeInsetsZero)
        return WidgetTemplateView.viewWithViewModel(viewModel, layoutSettings: layoutSettings)
    }()

    let view: UIView = UIView()

    init(source: GitHubSource) {
        sources = [source]

        let wrapperViewModel = WidgetTemplateViewModel(title: widgetTitle, subtitle: widgetSubtitle, contentView: widgetView)
        let layoutSettings = WidgetTemplateLayoutSettings(contentMargin: UIEdgeInsets(top: 36, left: 27, bottom: 0, right: 27))
        templatedWidgetView = WidgetTemplateView.viewWithViewModel(wrapperViewModel, layoutSettings: layoutSettings)
        displayView(templatedWidgetView)
    }

    func update(source: UpdatingSource) {
        if let source = source as? GitHubSource {
            updateRepositories(source)
        }
    }

    private func updateRepositories(source: GitHubSource) {
        source.read { [weak self] result in
            guard let `self` = self else { return }

            switch result {
            case .Success(let repos):
                guard repos.count > 0 else {
                    self.displayView(self.noOpenPullRequestsView)
                    break
                }
                let items = repos.flatMap { GitHubCellViewModel(forRepository: $0) }
                self.widgetView.configureWithViewModel(GitHubWidgetViewModel(cellItems: items))
                self.displayView(self.templatedWidgetView)
            case .Failure:
                self.displayView(self.errorView)
            }
        }
    }

    // MARK: - Showing views

    private func displayView(viewToDisplay: UIView) {
        [errorView, noOpenPullRequestsView, templatedWidgetView].filter { $0 != viewToDisplay }.forEach { $0.removeFromSuperview() }
        if !view.subviews.contains(viewToDisplay) {
            view.fillViewWithView(viewToDisplay, animated: false)
        }
    }
}
