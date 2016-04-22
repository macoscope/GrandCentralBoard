//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation


public protocol ConfigurationFetching {
    func fetchConfiguration(closure: (Result<Configuration>) -> ())
}

public enum ConfigurationError: ErrorType, HavingMessage {
    case WrongFormat

    public var message: String {
        switch self {
            case .WrongFormat:
                return NSLocalizedString("Wrong format of configuration file!", comment: "")
        }
    }
}

public struct Configuration {

    public let builders: [WidgetBuilding]
    public let settings: [WidgetSettings]

    public init(builders: [WidgetBuilding], settings: [WidgetSettings]) {
        self.builders = builders
        self.settings = settings
    }

    @warn_unused_result public static func configurationFromData(data: NSData, availableBuilders: [WidgetBuilding]) throws -> Configuration {

        if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
            if let widgets = jsonResult["widgets"] as? [AnyObject] {
                return Configuration(builders: availableBuilders, settings: WidgetSettings.settingsFromArray(widgets))
            }
        }

        throw ConfigurationError.WrongFormat
    }
}

public func == (lhs: Configuration, rhs: Configuration) -> Bool {

    for (index, settings) in lhs.settings.enumerate() {
        if rhs.settings[index].hashValue != settings.hashValue {
            return false
        }
    }

    return false // TODO: AAAA
}

extension Configuration : Equatable { }
