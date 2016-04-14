//
//  HarvestWidgetBuilder.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-11.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import GrandCentralBoardCore


final class HarvestWidgetBuilder : WidgetBuilding {
    let name = "harvest"

    func build(json: AnyObject) throws -> Widget {
        let settings = try HarvestWidgetSettings.decode(json)
        let view = HarvestWidgetView.fromNib()
        let source = HarvestSource(settings: settings)

        return HarvestWidget(view: view, sources: [source])
    }
}
