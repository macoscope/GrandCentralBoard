//
//  BonusWidgetBuilder.swift
//  GrandCentralBoard
//
//  Created by krris on 25/02/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation

final class BonusWidgetBuilder : WidgetBuilding {
    
    var name = "bonus"
    
    func build(settings: AnyObject) throws -> Widget {
        return BonusWidget(sources: [BonusSource()])
    }
}
