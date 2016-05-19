//
//  CircleChartViewModel.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 18.05.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit


struct CircleChartItem {
    let color: UIColor
    let ratio: Double
}

struct CircleChartViewModel {
    let items: [CircleChartItem]
}

extension CircleChartViewModel {

    static func chartViewModelFromBillingStats(stats: [DailyBillingStats]) -> CircleChartViewModel {
        var hoursPerUser = [Int: Double]()
        var workingDaysPerUser = [Int: Int]()
        stats.forEach { dayStat in
            dayStat.billings.forEach { userStat in
                workingDaysPerUser[userStat.userID] = (workingDaysPerUser[userStat.userID] ?? 0) + 1
                hoursPerUser[userStat.userID] = (hoursPerUser[userStat.userID] ?? 0) + userStat.hours
            }
        }

        let billingGroups = hoursPerUser.map { (userID, hours) -> BillingStatsGroupType in
            let workedDays = workingDaysPerUser[userID]!
            return BillingStatsGroupType.typeForHours( hours / Double(workedDays) )
        }

        let peopleWithHoursBelow = billingGroups.filter { $0 == .Less }.count
        let peopleWithHoursNormal = billingGroups.filter { $0 == .Normal }.count
        let peopleWithHoursAbove = billingGroups.filter { $0 == .More }.count

        let totalPeople = peopleWithHoursBelow + peopleWithHoursNormal + peopleWithHoursAbove
        guard totalPeople > 0 else {
            return CircleChartViewModel(items: [])
        }

        return CircleChartViewModel(items: [
            CircleChartItem(color: .hoursNormalColor(), ratio: Double(peopleWithHoursNormal) / Double(totalPeople)),
            CircleChartItem(color: .hoursLessColor(), ratio: Double(peopleWithHoursBelow) / Double(totalPeople)),
            CircleChartItem(color: .hoursMoreColor(), ratio: Double(peopleWithHoursAbove) / Double(totalPeople)),
            ])
    }
}
