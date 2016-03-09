//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
import Decodable
import Alamofire

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

enum ConfigurationError : ErrorType, HavingMessage {
    case DownloadFailed
    case WrongFormat

    var message: String {
        switch self {
            case .DownloadFailed:
                return NSLocalizedString("Cannot download configuration file!", comment: "")
            case .WrongFormat:
                return NSLocalizedString("Wrong format of configuration file!", comment: "")
        }
    }
}

struct ConfigurationDownloader {

    static func fetchConfiguration(fromPath path: String, closure: (Result<Configuration>) -> ()) {

        Alamofire.request(.GET, path).response { (request, response, data, error) in
            if let data = data {

                do {
                    closure(.Success(try Configuration.configurationFromData(data)))
                } catch (let error) {
                    closure(.Failure(error))
                }

                return
            }

            closure(.Failure(ConfigurationError.DownloadFailed))
        }
    }

}

struct Configuration {

    let builders: [WidgetBuilding]
    let settings: [WidgetSettings]

    static func configurationFromData(data: NSData) throws -> Configuration {

        if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
            if let widgets = jsonResult["widgets"] as? [AnyObject] {
                return Configuration(builders: availableBuilders, settings: WidgetSettings.settingsFromArray(widgets))
            }
        }

        throw ConfigurationError.WrongFormat
    }
}
