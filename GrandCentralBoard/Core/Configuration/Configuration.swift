//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation


/**
 Ability to fetch configuration.
 */
public protocol ConfigurationFetching {
    /**
     After attempt to fetch configuration closure with Result will be called.
     */
    func fetchConfiguration(closure: (Result<Configuration>) -> ())
}

/// The errors that `Configuration.configurationFromData(data:)` can throw.
public enum ConfigurationError: ErrorType, HavingMessage {
    case WrongFormat

    public var message: String {
        switch self {
            case .WrongFormat:
                return NSLocalizedString("Wrong format of configuration file!", comment: "")
        }
    }
}

/**
 This struct has configuration information for `GrandCentralBoard` to display and update widgets.
 */
public struct Configuration {

    public let builders: [WidgetBuilding]
    public let settings: [WidgetSettings]

    public init(builders: [WidgetBuilding], settings: [WidgetSettings]) {
        self.builders = builders
        self.settings = settings
    }

    @warn_unused_result public static func configurationFromData(data: NSData, availableBuilders: [WidgetBuilding]) throws -> Configuration {

        if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
            if let widgets = jsonResult["widgets"] as? [AnyObject] {
                return try Configuration(builders: availableBuilders, settings: WidgetSettings.settingsFromArray(widgets))
            }
        }

        throw ConfigurationError.WrongFormat
    }
}

public func == (lhs: Configuration, rhs: Configuration) -> Bool {

    guard lhs.settings.count == rhs.settings.count else {
        return false
    }

    for (index, settings) in lhs.settings.enumerate() {
        if rhs.settings[index] == settings {
            return false
        }
    }

    return true
}

extension Configuration : Equatable { }
