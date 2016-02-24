//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation

struct WidgetSettings {
    let key: String
    let settings: [String : String]
}

struct Configuration {
    let builders: [WidgetBuilding]
    let settings: [WidgetSettings]

    static func settingsFromDictionary(dictionary: [String : AnyObject]) -> [WidgetSettings] {

        return []
    }
}