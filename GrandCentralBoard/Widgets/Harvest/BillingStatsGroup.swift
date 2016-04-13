//
//  BillingStatsGroup.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-13.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

struct BillingStatsGroup {
    enum Type {
        case Less
        case Normal
        case More
    }

    let type: Type
    let count: Int
    let averageHours: Double
}
