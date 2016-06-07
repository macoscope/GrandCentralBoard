//
//  Created by Oktawian Chojnacki on 21.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation


/// This class will attempt to fetch configuration with certain frequency defined by `interval` property.
public final class ConfigurationRefresher: Schedulable {

    private let scheduler: SchedulingJobs
    private let fetcher: ConfigurationFetching
    private weak var configuree: Configurable?

    public let interval: NSTimeInterval
    public let selector: Selector = #selector(fetch)

    /**
     Initialize `ConfigurationRefresher`.

     - parameter interval:   time interval between refresh attempts.
     - parameter configuree: subject being reconfigured each time refresh operation succeed.
     - parameter fetcher:    class downloading data.
     - parameter scheduler:  class scheduling events.
     */
    public init(interval: NSTimeInterval,
                configuree: Configurable,
                fetcher: ConfigurationFetching,
                scheduler: SchedulingJobs = Scheduler()) {

        self.scheduler = scheduler
        self.fetcher = fetcher
        self.interval = interval
        self.configuree = configuree
    }

    /**
     Start refreshing configuration.
     */
    public func start() {
        scheduler.schedule(self)
    }

    @objc private func fetch() {
        fetcher.fetchConfiguration { [weak self] result in
            switch result {
            case .Success(let configuration):
                do {
                    try self?.configuree?.configure(configuration)
                } catch (let error) {
                    print("ConfigurationRefresher Error: '\(error)'")
                }
            case .Failure(let error):
                print("ConfigurationRefresher Error: '\(error)'")
            }
        }
    }
}
