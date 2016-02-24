//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation

let availableBuilders: [WidgetBuilding] = [WatchWidgetBuilder()]

struct WidgetSettings {
    let key: String
    let settings: [String : String]

    static func settingsFromArray(array: [[String : [String : String]]]) -> [WidgetSettings] {

        return array.flatMap({ settings in

            if let key = settings.keys.first, settingsForKey = settings[key] {
                return WidgetSettings(key: key, settings: settingsForKey)
            }

            return nil
        })
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

        if let path = NSBundle.mainBundle().pathForResource("configuration", ofType: "json") {
            if let jsonData = NSData(contentsOfFile: path) {
                return try configurationFromData(jsonData)
            }
        }

        throw ConfigurationException.NoConfigurationFile
    }

    private static func configurationFromData(data: NSData) throws -> Configuration {

        if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
            if let widgets = jsonResult["widgets"] as? [[String : [String : String]]] {
                let array = widgets.map({ $0 as [String : [String : String]] })
                return Configuration(builders: availableBuilders, settings: WidgetSettings.settingsFromArray(array))
            }
        }

        throw ConfigurationException.WrongConfigurationFormat
    }
}
