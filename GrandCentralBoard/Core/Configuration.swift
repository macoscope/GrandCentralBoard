//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
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

extension WidgetSettings : Decodable {
    public static func decode(jsonObject: AnyObject) throws -> WidgetSettings {
        return try WidgetSettings(name: jsonObject => "name", settings: jsonObject => "settings")
    }
}

public protocol ConfigurationFetching {
    func fetchConfiguration(closure: (Result<Configuration>) -> ())
}

public final class LocalConfiguration : ConfigurationFetching {

    private let configFileName: String
    private let availableBuilders: [WidgetBuilding]

    public init(configFileName: String, availableBuilders: [WidgetBuilding]) {
        self.configFileName = configFileName
        self.availableBuilders = availableBuilders
    }

    public func fetchConfiguration(closure: (Result<Configuration>) -> ()) {
         guard let path = NSBundle.mainBundle().pathForResource(configFileName, ofType: "json"),
                   data = NSData(contentsOfFile: path) else {

            closure(.Failure(ConfigurationError.NoFile))

            return
        }

        do {
            closure(.Success(try Configuration.configurationFromData(data, availableBuilders: availableBuilders)))
        } catch (let error) {
            closure(.Failure(error))
        }
    }
}

public final class ConfigurationDownloader : ConfigurationFetching {
    
    private let dataDownloader: DataDownloading
    private let path: String
    private let builders: [WidgetBuilding]
    
    public init(dataDownloader: DataDownloading, path: String, builders: [WidgetBuilding]) {
        self.path = path
        self.builders = builders
        self.dataDownloader = dataDownloader
    }
    
    public func fetchConfiguration(closure: (Result<Configuration>) -> ()) {
        dataDownloader.downloadDataAtPath(path) { [weak self] result in
            switch result {
                case .Success(let data):
                    do {
                        guard let instance = self else { return }
                        closure(.Success(try Configuration.configurationFromData(data, availableBuilders: instance.builders)))
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
    case NoFile
    
    public var message: String {
        switch self {
            case .WrongFormat:
                return NSLocalizedString("Wrong format of configuration file!", comment: "")
            case .NoFile:
                return NSLocalizedString("Local configuration file not found!", comment: "")
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
