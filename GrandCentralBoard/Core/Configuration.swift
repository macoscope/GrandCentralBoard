//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
import Decodable

private let dataDownloader = DataDownloader()
private let availableBuilders: [WidgetBuilding] = [WatchWidgetBuilder(dataDownloader: dataDownloader)]

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
    static func decode(jsonObject: AnyObject) throws -> WidgetSettings {
        return try WidgetSettings(name: jsonObject => "name", settings: jsonObject => "settings")
    }
}

final class ConfigurationDownloader {

    private let dataDownloader: DataDownloading

    init(dataDownloader: DataDownloading) {
        self.dataDownloader = dataDownloader
    }

    func fetchConfiguration(fromPath path: String, closure: (Result<Configuration>) -> ()) {
        dataDownloader.downloadDataAtPath(path) { result in
            switch result {
                case .Success(let data):
                    do {
                        closure(.Success(try Configuration.configurationFromData(data)))
                    } catch (let error) {
                        closure(.Failure(error))
                    }
                case .Failure(let error):
                    closure(.Failure(error))
            }
        }
    }

}

enum ConfigurationError : ErrorType, HavingMessage {
    case WrongFormat

    var message: String {
        switch self {
            case .WrongFormat:
                return NSLocalizedString("Wrong format of configuration file!", comment: "")
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
