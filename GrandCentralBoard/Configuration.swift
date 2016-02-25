//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
import Decodable

let availableBuilders: [WidgetBuilding] = [WatchWidgetBuilder()]

struct WidgetSettings {
    let name: String
    let settings: AnyObject

    static func settingsFromArray(array: [AnyObject]) -> [WidgetSettings] {
        return array.flatMap({ settings in
            return try? WidgetSettings.decode(settings)
        })
    }
}

extension WidgetSettings : Decodable {
    static func decode(j: AnyObject) throws -> WidgetSettings {
        return try WidgetSettings(name: j => "name", settings: j => "settings")
    }
}

enum ConfigurationException : ErrorType {
    case NoConfigurationFile
    case WrongConfigurationFormat
}

struct Configuration {

    let builders: [WidgetBuilding]
    let settings: [WidgetSettings]

    static func defaultConfiguration() throws -> Configuration {

        // TODO: Fetch from server.


        if let path = NSBundle.mainBundle().pathForResource("configuration", ofType: "json") {
            if let jsonData = NSData(contentsOfFile: path) {
                return try configurationFromData(jsonData)
            }
        }

        throw ConfigurationException.NoConfigurationFile
    }

    private static func configurationFromData(data: NSData) throws -> Configuration {

        if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
            if let widgets = jsonResult["widgets"] as? [AnyObject] {
                return Configuration(builders: availableBuilders, settings: WidgetSettings.settingsFromArray(widgets))
            }
        }

        throw ConfigurationException.WrongConfigurationFormat
    }
}
