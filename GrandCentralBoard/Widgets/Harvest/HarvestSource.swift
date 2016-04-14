//
//  HarvestSource.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-11.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import GrandCentralBoardCore


final class HarvestSource : Asynchronous {
    typealias ResultType = Result<[DailyBillingStats]>
    let interval: NSTimeInterval
    let sourceType: SourceType = .Momentary
    let harvestAPI: HarvestAPI

    init(settings: HarvestWidgetSettings) {
        self.harvestAPI = HarvestAPI(account: settings.account, refreshCredentials: settings.refreshCredentials, downloader: settings.downloader)
        self.interval = settings.refreshInterval
    }

    func read(callback: (ResultType) -> Void) {
        harvestAPI.refreshTokenIfNeeded { _ in
            self.harvestAPI.fetchBillingStats(callback)
        }
    }
}
