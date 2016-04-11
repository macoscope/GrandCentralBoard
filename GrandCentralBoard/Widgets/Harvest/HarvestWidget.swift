//
//  HarvestWidget.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-11.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import GrandCentralBoardCore


final class HarvestWidget: Widget {
    let view: UIView
    let sources: [UpdatingSource]

    init(view: HarvestWidgetView, sources: [UpdatingSource]) {
        self.view = view
        self.sources = sources
    }

    func update(source: UpdatingSource) {
        guard let source = source as? HarvestSource else { return }

        source.read({ (result: Result<HarvestTeamData>) in
            self.updateView(result)
        })
    }

    func updateView(result: Result<HarvestTeamData>) {
    }
}
