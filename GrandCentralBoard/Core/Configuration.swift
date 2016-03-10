//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
import Decodable

public struct WidgetSettings {
    public let name: String
    public let settings: AnyObject

    public static func settingsFromArray(array: [AnyObject]) -> [WidgetSettings] {
        return array.flatMap({ settings in
            return try? WidgetSettings.decode(settings)
        })
    }
}

extension WidgetSettings : Decodable {
    public static func decode(jsonObject: AnyObject) throws -> WidgetSettings {
        return try WidgetSettings(name: jsonObject => "name", settings: jsonObject => "settings")
    }
}

public final class ConfigurationDownloader {

    private let dataDownloader: DataDownloading

    public init(dataDownloader: DataDownloading) {
        self.dataDownloader = dataDownloader
    }

    public func fetchConfiguration(fromPath path: String, availableBuilders: [WidgetBuilding], closure: (Result<Configuration>) -> ()) {
        dataDownloader.downloadDataAtPath(path) { result in
            switch result {
                case .Success(let data):
                    do {
                        closure(.Success(try Configuration.configurationFromData(data, availableBuilders: availableBuilders)))
                    } catch (let error) {
                        closure(.Failure(error))
                    }
                case .Failure(let error):
                    closure(.Failure(error))
            }
        }
    }

}

public enum ConfigurationError : ErrorType, HavingMessage {
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

    public static func configurationFromData(data: NSData, availableBuilders: [WidgetBuilding]) throws -> Configuration {

        if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
            if let widgets = jsonResult["widgets"] as? [AnyObject] {
                return Configuration(builders: availableBuilders, settings: WidgetSettings.settingsFromArray(widgets))
            }
        }

        throw ConfigurationError.WrongFormat
    }
}
