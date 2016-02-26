//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
import Decodable

enum WatchWidgetBuilderException : ErrorType {
    case WrongTimeZoneIdentifier
    case WrongSettings
}

struct WatchSettings : Decodable {
    let timeZone: String

    static func decode(json: AnyObject) throws -> WatchSettings {
        return try WatchSettings(timeZone: json => "timeZone")
    }
}



final class WatchWidgetBuilder : WidgetBuilding {

    let name = "watch"

    func build(settings: AnyObject) throws -> Widget {
        if let settings = try? WatchSettings.decode(settings) {
            if let zone = NSTimeZone(name: settings.timeZone) {
                let timeSource = TimeSource(zone: zone)
                return WatchWidget(source: timeSource)
            }
            
            throw WatchWidgetBuilderException.WrongTimeZoneIdentifier
        }

        throw WatchWidgetBuilderException.WrongSettings
    }
}