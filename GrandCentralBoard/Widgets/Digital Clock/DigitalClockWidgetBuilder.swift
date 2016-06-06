//
//  DigitalClockWidgetBuilder.swift
//  GrandCentralBoard
//
//  Created by Joel Fischer on 4/22/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import GCBCore

final class DigitalClockWidgetBuilder: WidgetBuilding {
    let name = "digital clock"

    func build(settings: AnyObject) throws -> WidgetControlling {
        let clockSettings = try DigitalClockSourceSettings.decode(settings)
        let clockSource = DigitalClockSource(settings: clockSettings)

        let view = DigitalClockWidgetView.fromNib()
        return DigitalClockWidget(view: view, sources: [clockSource])
    }
}
