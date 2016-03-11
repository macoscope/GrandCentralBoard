//
//  Created by Krzysztof Werys on 24/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import UIKit
import GrandCentralBoardCore

final class BonusWidget : Widget {
    
    private let widgetView: BonusWidgetView
    let sources: [UpdatingSource]
    
    private var mapping: Mapping?
    
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
                source.mapping = mapping
                updateBonusFromSource(source)
            case let source as ImageMappingSource:
                updateFromImageMappingSource(source)
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
    
    private func updateFromImageMappingSource(source: ImageMappingSource) {
        source.read { result in
            switch result {
                case .Success(let mapping):
                    self.mapping = mapping
                case .Failure:
                    break
            }
        }
    }
}
