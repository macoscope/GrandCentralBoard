//
//  Created by Krzysztof Werys on 24/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import UIKit

final class BonusWidget : Widget {
    
    private let widgetView: BonusWidgetView
    let sources: [UpdatingSource]
    
    init(sources: [UpdatingSource]) {
        self.widgetView = BonusWidgetView.fromNib()
        self.sources = sources
    }
    
    var view: UIView {
        return widgetView
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
                    let bonusViewModel = BonusWidgetViewModel(sceneModel: BonusSceneModel(people: people))
                    self.widgetView.render(bonusViewModel)
                case .Failure:
                    self.widgetView.failure()
            }
        }

    }
}