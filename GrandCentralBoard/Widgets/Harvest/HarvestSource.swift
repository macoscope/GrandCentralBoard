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

    private let oauthCredentials: OAuthCredentials

    init(settings: HarvestWidgetSettings) {
        self.oauthCredentials = settings.oauthCredentials
        self.interval = settings.refreshInterval
    }

    func read(callback: (ResultType) -> Void) {
        dispatch_async(dispatch_get_main_queue()) {
            let groups = [
                BillingStatsGroup(type: .Less,   count: 10, averageHours: 4.5),
                BillingStatsGroup(type: .Normal, count: 4,  averageHours: 6.4),
                BillingStatsGroup(type: .More,   count: 15, averageHours: 8.1)
            ]
            let dailyStats = DailyBillingStats(day: NSDate(), groups: groups)

            callback(.Success([dailyStats]))
        }
    }
}
