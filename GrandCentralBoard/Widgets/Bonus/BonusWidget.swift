//
//  Created by Krzysztof Werys on 24/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import UIKit
import GCBCore

final class BonusWidget: WidgetControlling {

    private let widgetView: BonusWidgetView
    private let widgetViewWrapper: UIView

    private lazy var errorView: UIView = {
        let viewModel = WidgetErrorTemplateViewModel(title: "Bonusly".localized.uppercaseString,
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

        let viewModel = WidgetTemplateViewModel(title: "Bonusly".localized.uppercaseString,
                                                subtitle: "Last \(numberOfBubbles) people".localized.uppercaseString,
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
        source.read { result in
            switch result {
                case .Success(let people):
                    self.hideErrorView()
                    let bonusViewModel = BonusWidgetViewModel(people: people, bubbleResizeDuration: self.bubbleResizeDuration)
                    self.widgetView.render(bonusViewModel)
                case .Failure:
                    self.displayErrorView()
                    self.widgetView.failure()
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
