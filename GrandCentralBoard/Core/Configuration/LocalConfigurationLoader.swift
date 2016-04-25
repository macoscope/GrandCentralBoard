//
//  Created by Oktawian Chojnacki on 23.03.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation


public enum LocalConfigurationLoaderError: ErrorType, HavingMessage {
    case NoFile

    public var message: String {
        switch self {
            case .NoFile:
                return NSLocalizedString("Local configuration file not found!", comment: "")
        }
    }
}

/// This class will fetch configuration file bundled with the application.
public final class LocalConfigurationLoader: ConfigurationFetching {

    private let configFileName: String
    private let availableBuilders: [WidgetBuilding]

    /**
     Initialize `LocalConfigurationLoader`.

     - parameter configFileName:    configuration filename without extension, **.json** is assumed.
     - parameter availableBuilders: collection of subjects building widgets of different kinds.
     */
    public init(configFileName: String, availableBuilders: [WidgetBuilding]) {
        self.configFileName = configFileName
        self.availableBuilders = availableBuilders
    }

    public func fetchConfiguration(closure: (Result<Configuration>) -> ()) {
        guard let path = NSBundle.mainBundle().pathForResource(configFileName, ofType: "json"),
            data = NSData(contentsOfFile: path) else {

                closure(.Failure(LocalConfigurationLoaderError.NoFile))

                return
        }

        do {
            let configuration = try Configuration.configurationFromData(data, availableBuilders: availableBuilders)
            closure(.Success(configuration))
        } catch (let error) {
            closure(.Failure(error))
        }
    }
}
