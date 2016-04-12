//
//  HarvestSource.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-11.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import GrandCentralBoardCore


final class HarvestSource : Asynchronous {
    typealias ResultType = Result<HarvestTeamStats>
    let interval: NSTimeInterval
    let sourceType: SourceType = .Momentary

    private let oauthCredentials: OAuthCredentials

    init(settings: HarvestWidgetSettings) {
        self.oauthCredentials = settings.oauthCredentials
        self.interval = settings.refreshInterval
    }

    func read(callback: (ResultType) -> Void) {
        dispatch_async(dispatch_get_main_queue()) {
            let date = NSDate()
            let groups = [
                HarvestTeamStatsGroupType.Less:   HarvestTeamStatsGroup(type: .Less,   count: 10, averageWorkTime: 16200),
                HarvestTeamStatsGroupType.Normal: HarvestTeamStatsGroup(type: .Normal, count: 4,  averageWorkTime: 24000),
                HarvestTeamStatsGroupType.More:   HarvestTeamStatsGroup(type: .More,   count: 15, averageWorkTime: 36000)
            ]
            let dailyStats = [
                HarvestDailyTeamStats(day: date, groups: groups)
            ]

            let teamData = HarvestTeamStats(updateDate: date, dailyStats: dailyStats)

            callback(.Success(teamData))
        }
    }
}
