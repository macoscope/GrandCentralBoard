//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
import Decodable

enum WatchWidgetBuilderException : ErrorType {
    case WrongSettings
}

final class WatchWidgetBuilder : WidgetBuilding {

    let name = "watch"

    func build(settings: AnyObject) throws -> Widget {

        if let settings = try? TimeSourceSettings.decode(settings) {
            let timeSource = TimeSource(settings: settings)
            return WatchWidget(source: timeSource)
        }

        throw WatchWidgetBuilderException.WrongSettings
    }
}