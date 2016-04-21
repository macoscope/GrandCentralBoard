//
//  BillingStatsGroup.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-13.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

struct BillingStatsGroup {
    let type: BillingStatsGroupType
    let count: Int
    let averageHours: Double
}


enum BillingStatsGroupType: Int {
    case Less
    case Normal
    case More
}


extension BillingStatsGroup {
    static func typeForHours(hours: Double) -> BillingStatsGroupType {
        if hours < 6.3 {
            return .Less

        } else if hours < 6.7 {
            return .Normal

        } else {
            return .More
        }
    }

    static func allTypes() -> [BillingStatsGroupType] {
        return [.Less, .Normal, .More]
    }
}
