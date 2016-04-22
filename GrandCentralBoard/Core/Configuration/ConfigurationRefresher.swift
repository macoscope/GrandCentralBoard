//
//  Created by Oktawian Chojnacki on 21.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation


final class ConfigurationRefresher: Schedulable {

    private let scheduler: SchedulingJobs
    private let fetcher: ConfigurationFetching
    private weak var configuree: Configurable?

    let interval: NSTimeInterval
    let selector: Selector = #selector(fetch)

    init(interval: NSTimeInterval, fetcher: ConfigurationFetching, scheduler: SchedulingJobs = Scheduler()) {
        self.scheduler = scheduler
        self.fetcher = fetcher
        self.interval = interval
    }

    func start() {
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