//
//  AnalogClockWidgetBuilder.swift
//  GrandCentralBoard
//
//  Created by Joel Fischer on 4/22/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import GCBCore

final class AnalogClockWidgetBuilder: WidgetBuilding {
    let name = "analog clock"

    func build(settings: AnyObject) throws -> WidgetControlling {
        let clockSettings = try AnalogAnalogClockSourceSettings.decode(settings)
        let source = AnalogClockSource(settings: clockSettings)
        let view = AnalogClockWidgetView.fromNib()

        return AnalogClockWidget(view: view, sources: [source])
    }
}
