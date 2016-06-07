//
//  Created by Krzysztof Werys on 24/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import UIKit
import GCBCore
import GCBUtilities


private let widgetTitle = "Bonusly".localized.uppercaseString

final class BonusWidget: WidgetControlling {

    private let widgetView: BonusWidgetView
    private let widgetViewWrapper: UIView

    private lazy var errorView: UIView = {
        let viewModel = WidgetErrorTemplateViewModel(title: widgetTitle,
                                                     subtitle: "Error".localized.uppercaseString)
        return WidgetTemplateView.viewWithErrorViewModel(viewModel)
    }()

    let sources: [UpdatingSource]
    let bubbleResizeDuration: NSTimeInterval
    let numberOfBubbles: Int

    init(sources: [UpdatingSource], bubbleResizeDuration: NSTimeInterval, numberOfBubbles: Int) {
        self.widgetView = BonusWidgetView.fromNib()
        self.sources = sources
        self.bubbleResizeDuration = bubbleResizeDuration
        self.numberOfBubbles = numberOfBubbles

        let viewModel = WidgetTemplateViewModel(title: widgetTitle,
                                                subtitle: String(format: "Last %d people".localized, numberOfBubbles).uppercaseString,
                                                contentView: widgetView)
        let layoutSettings = WidgetTemplateLayoutSettings(contentMargin: UIEdgeInsetsZero)
        widgetViewWrapper = WidgetTemplateView.viewWithViewModel(viewModel, layoutSettings: layoutSettings)
    }

    var view: UIView {
        return widgetViewWrapper
    }

    func update(source: UpdatingSource) {
        switch source {
            case let source as BonusSource:
                updateBonusFromSource(source)
            default:
                assertionFailure("Expected `source` as instance of `BonusSource`.")
        }
    }

    private func updateBonusFromSource(source: BonusSource) {
        source.read { [weak self] result in
            guard let strongSelf = self else { return }

            switch result {
                case .Success(let people):
                    strongSelf.hideErrorView()
                    let bonusViewModel = BonusWidgetViewModel(people: people, bubbleResizeDuration: strongSelf.bubbleResizeDuration)
                    strongSelf.widgetView.render(bonusViewModel)
                case .Failure:
                    strongSelf.displayErrorView()
                    strongSelf.widgetView.failure()
            }
        }
    }

    private func displayErrorView() {
        guard !view.subviews.contains(errorView) else { return }
        view.fillViewWithView(errorView, animated: false)
    }

    private func hideErrorView() {
        errorView.removeFromSuperview()
    }

}
