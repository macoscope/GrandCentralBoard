//
//  HarvestTeamData.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-11.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation


struct HarvestTeamData {
    let date: NSDate
    let groups: [HarvestTeamDataGroup]
}

struct HarvestTeamDataGroup {
    let name: String
    let size: Int
    let averageWorkTime: NSTimeInterval
}
