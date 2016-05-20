//
//  HarvestSource.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-11.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import GCBCore


final class HarvestSource: Asynchronous {
    typealias ResultType = Result<[DailyBillingStats]>
    let interval: NSTimeInterval
    let sourceType: SourceType = .Momentary
    let harvestAPI: HarvestAPIProviding

    init(apiProvider: HarvestAPIProviding, refreshInterval: NSTimeInterval) {
        harvestAPI = apiProvider
        interval = refreshInterval
    }

    func read(callback: (ResultType) -> Void) {
        harvestAPI.refreshTokenIfNeeded { _ in
            self.harvestAPI.fetchBillingStats(callback)
        }
    }
}
