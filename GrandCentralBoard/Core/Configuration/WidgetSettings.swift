//
//  Created by Oktawian Chojnacki on 23.03.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Decodable


public struct WidgetSettings {
    public let name: String
    public let settings: AnyObject

    public init(name: String, settings: AnyObject) {
        self.name = name
        self.settings = settings
    }

    @warn_unused_result public static func settingsFromArray(array: [AnyObject]) -> [WidgetSettings] {
        return array.flatMap({ settings in
            return try? WidgetSettings.decode(settings)
        })
    }
}

extension WidgetSettings : Hashable {
    public var hashValue: Int {

        if let settings = settings as? [String : AnyObject] {
            return settings.enumerate().reduce(name.hashValue) { previousHash, widgetSettings in

                let key = widgetSettings.element.0
                let value = widgetSettings.element.1

                var valueHash: Int?

                if let string = value as? String {
                    valueHash = string.hashValue
                }

                if let number = widgetSettings.element.1 as? NSNumber {
                    valueHash = number.integerValue
                }

                if let valueHash = valueHash {
                    return previousHash ^ key.hashValue ^ valueHash
                }

                if widgetSettings.element.1 is NSNull {
                    return previousHash ^ key.hashValue
                }

                return previousHash
            }
        }

        return 0
    }
}

public func == (lhc: WidgetSettings, rhc: WidgetSettings) -> Bool {
    return lhc.hashValue == rhc.hashValue
}

extension WidgetSettings : Decodable {
    public static func decode(jsonObject: AnyObject) throws -> WidgetSettings {
        return try WidgetSettings(name: jsonObject => "name", settings: jsonObject => "settings")
    }
}
