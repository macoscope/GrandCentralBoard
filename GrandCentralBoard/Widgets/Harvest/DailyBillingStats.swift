//
//  HarvestTeamStats.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-11.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Decodable


struct DailyBillingStats {
    let day: NSDate
    let groups: [BillingStatsGroup]
}
