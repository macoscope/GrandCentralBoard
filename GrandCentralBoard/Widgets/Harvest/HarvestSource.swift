//
//  HarvestSource.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-11.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import GrandCentralBoardCore


class HarvestSource: Asynchronous {
    typealias ResultType = Result<HarvestTeamData>

    let oauthCredentials: OAuthCredentials
    let interval: NSTimeInterval
    let sourceType: SourceType = .Momentary

    init(settings: HarvestWidgetSettings) {
        self.oauthCredentials = settings.oauthCredentials
        self.interval = settings.refreshInterval
    }

    func read(callback: (ResultType) -> Void) {
        dispatch_async(dispatch_get_main_queue()) {
            let date = NSDate()
            let groups = [
                HarvestTeamDataGroup(name: "<6.5",  size: 10, averageWorkTime: 16200),
                HarvestTeamDataGroup(name: "~6.5",  size: 4,  averageWorkTime: 24000),
                HarvestTeamDataGroup(name: ">6.5",  size: 15, averageWorkTime: 36000),
            ]
            let teamData = HarvestTeamData(date: date, groups: groups)

            callback(.Success(teamData))
        }
    }
}
