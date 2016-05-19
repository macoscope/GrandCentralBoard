//
//  BillingStatsGroup.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-13.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

enum BillingStatsGroupType: Int {
    case Less
    case Normal
    case More

    static func typeForHours(hours: Double) -> BillingStatsGroupType {
        if hours < 6.3 {
            return .Less

        } else if hours < 6.7 {
            return .Normal

        } else {
            return .More
        }
    }
}
