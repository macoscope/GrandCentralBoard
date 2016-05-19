//
//  Created by Krzysztof Werys on 24/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import UIKit
import GCBCore

final class BonusWidget: WidgetControlling {

    private let widgetView: BonusWidgetView
    let sources: [UpdatingSource]
    let bubbleResizeDuration: NSTimeInterval
    let numberOfPeople: Int

    init(sources: [UpdatingSource], bubbleResizeDuration: NSTimeInterval, numberOfPeople: Int) {
        self.widgetView = BonusWidgetView.fromNib()
        self.sources = sources
        self.bubbleResizeDuration = bubbleResizeDuration
        self.numberOfPeople = numberOfPeople
    }

    var view: UIView {
        let viewModel = WidgetTemplateViewModel(title: "BONUSLY", subtitle: "LAST \(numberOfPeople) PEOPLE", contentView: widgetView)
        let layoutSettings = WidgetTemplateLayoutSettings(contentMargin: UIEdgeInsetsZero)
        let templateView = WidgetTemplateView.viewWithViewModel(viewModel, layoutSettings: layoutSettings)
        return templateView
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
                    let bonusViewModel = BonusWidgetViewModel(people: people, bubbleResizeDuration: self.bubbleResizeDuration)
                    self.widgetView.render(bonusViewModel)
                case .Failure:
                    self.widgetView.failure()
            }
        }
    }

}
