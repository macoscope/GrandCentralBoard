//
//  Created by Oktawian Chojnacki on 23.03.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation


/// This class is for downloading configuration from remote source.
public final class ConfigurationDownloader: ConfigurationFetching {

    private let dataDownloader: DataDownloading
    private let path: String
    private let builders: [WidgetBuilding]

    /**
     Initialize `ConfigurationDownloader`.

     - parameter dataDownloader: class downloading data from remote source.
     - parameter path:           path to remote source.
     - parameter builders:       available builders.
     */
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
