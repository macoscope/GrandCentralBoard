//
//  HarvestStats.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-11.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation

struct HarvestTeamStats {
    let updateDate: NSDate
    let dailyStats: [HarvestDailyTeamStats]
}

struct HarvestDailyTeamStats {
    let day: NSDate
    let groups: [HarvestTeamStatsGroupType: HarvestTeamStatsGroup]
}

struct HarvestTeamStatsGroup {
    let type: HarvestTeamStatsGroupType
    let count: Int
    let averageWorkTime: NSTimeInterval
}

enum HarvestTeamStatsGroupType {
    case Less
    case Normal
    case More
}
