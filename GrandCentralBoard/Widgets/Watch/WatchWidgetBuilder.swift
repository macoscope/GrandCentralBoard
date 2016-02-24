//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation

enum WatchWidgetBuilderException : ErrorType {
    case WrongTimeZoneIdentifier
    case WrongSettings
}

final class WatchWidgetBuilder : WidgetBuilding {

    private let timeZoneKey = "timeZone"

    let key = "watch"

    func build(settings: [String : String]) throws -> Widget {
        if let timeZone = settings[timeZoneKey] {
            if let zone = NSTimeZone(name: timeZone) {
                let timeSource = TimeSource(zone: zone)
                return WatchWidget(source: timeSource)
            }
            
            throw WatchWidgetBuilderException.WrongTimeZoneIdentifier
        }

        throw WatchWidgetBuilderException.WrongSettings
    }
}