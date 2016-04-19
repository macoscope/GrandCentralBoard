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

public final class LocalConfigurationLoader: ConfigurationFetching {

    private let configFileName: String
    private let availableBuilders: [WidgetBuilding]

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
            closure(.Success(try Configuration.configurationFromData(data, availableBuilders: availableBuilders)))
        } catch (let error) {
            closure(.Failure(error))
        }
    }
}
