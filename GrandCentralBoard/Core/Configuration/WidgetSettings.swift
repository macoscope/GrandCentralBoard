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
            return settings.enumerate().reduce(name.hashValue) { first, second in

                if let string = second.element.1 as? String {
                    return first ^ second.element.0.hashValue ^ string.hashValue
                }

                if let number = second.element.1 as? NSNumber {
                    return first ^ second.element.0.hashValue ^ number.hashValue
                }

                if second.element.1 is NSNull {
                    return first ^ second.element.0.hashValue
                }

                return first
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
