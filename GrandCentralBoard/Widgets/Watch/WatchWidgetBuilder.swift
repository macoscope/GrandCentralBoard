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

    let name = "watch"

    func build(settings: AnyObject) throws -> Widget {
        if let settingsDictionary = settings as? [String : String], timeZone = settingsDictionary[timeZoneKey] {
            if let zone = NSTimeZone(name: timeZone) {
                let timeSource = TimeSource(zone: zone)
                return WatchWidget(source: timeSource)
            }
            
            throw WatchWidgetBuilderException.WrongTimeZoneIdentifier
        }

        throw WatchWidgetBuilderException.WrongSettings
    }
}