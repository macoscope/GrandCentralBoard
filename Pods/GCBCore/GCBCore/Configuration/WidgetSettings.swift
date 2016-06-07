//
//  Created by Oktawian Chojnacki on 23.03.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Decodable

/**
 This struct contains name and settigs for one widget.
 */
public struct WidgetSettings {
    /// Name specifying which Widget Builder should be used.
    public let name: String
    /// Deserialized settings section of configuration file.
    public let settings: AnyObject

    public init(name: String, settings: AnyObject) {
        self.name = name
        self.settings = settings
    }

    /**
     Generate array of `WidgetSettings` from deserialized settings.

     - parameter array: contains deserialized settings (in form of NSDictionary)
     - throws: Decodable exception
     - returns: array of `WidgetSettings`
     */
    @warn_unused_result public static func settingsFromArray(array: [AnyObject]) throws -> [WidgetSettings] {
        return try array.flatMap({ settings in
            return try WidgetSettings.decode(settings)
        })
    }
}

extension WidgetSettings : Equatable { }

public func == (lhs: WidgetSettings, rhs: WidgetSettings) -> Bool {
    if lhs.name != rhs.name {
        return false
    }

    if let lhsSettings = lhs.settings as? [String: AnyObject],
        let rhsSettings = rhs.settings as? [String: AnyObject] {

        return NSDictionary(dictionary: lhsSettings).isEqualToDictionary(rhsSettings)
    }

    return false
}

extension WidgetSettings : Decodable {
    public static func decode(jsonObject: AnyObject) throws -> WidgetSettings {
        return try WidgetSettings(name: jsonObject => "name", settings: jsonObject => "settings")
    }
}
