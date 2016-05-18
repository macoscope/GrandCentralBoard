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
    let startAngle: Double
    let items: [CircleChartItem]
}

extension CircleChartViewModel {

    static func chartViewModelFromBillingStats(stats: DailyBillingStats) -> CircleChartViewModel {
        let peopleWithHoursBelow = stats.groups.filter { $0.type == .Less }.first?.count ?? 0
        let peopleWithHoursNormal = stats.groups.filter { $0.type == .Normal }.first?.count ?? 0
        let peopleWithHoursAbove = stats.groups.filter { $0.type == .More }.first?.count ?? 0

        let totalPeople = stats.groups.reduce(0) { $0 + $1.count }
        guard totalPeople > 0 else {
            return CircleChartViewModel(startAngle: 0, items: [])
        }

        return CircleChartViewModel(startAngle: 0, items: [
            CircleChartItem(color: .hoursNormalColor(), ratio: Double(peopleWithHoursNormal) / Double(totalPeople)),
            CircleChartItem(color: .hoursMoreColor(), ratio: Double(peopleWithHoursAbove) / Double(totalPeople)),
            CircleChartItem(color: .hoursLessColor(), ratio: Double(peopleWithHoursBelow) / Double(totalPeople)),
            ])
    }

    static func chartViewModelFromMultipleBillingStats(stats: [DailyBillingStats]) -> CircleChartViewModel {
        var manDayTypes = [BillingStatsGroupType: Int]()
        stats.forEach { stat in
            stat.groups.forEach { group in
                manDayTypes[group.type] = (manDayTypes[group.type] ?? 0) + group.count
            }
        }

        let totalManDays = manDayTypes.reduce(0) { $0 + $1.1 }
        guard totalManDays > 0 else {
            return CircleChartViewModel(startAngle: 0, items: [])
        }

        var circleChartItems = [CircleChartItem]()
        if let manDaysNormal = manDayTypes[.Normal] {
            circleChartItems.append(CircleChartItem(color: .hoursNormalColor(), ratio: Double(manDaysNormal) / Double(totalManDays)))
        }
        if let manDaysMore = manDayTypes[.More] {
            circleChartItems.append(CircleChartItem(color: .hoursMoreColor(), ratio: Double(manDaysMore) / Double(totalManDays)))
        }
        if let manDaysLess = manDayTypes[.Less] {
            circleChartItems.append(CircleChartItem(color: .hoursLessColor(), ratio: Double(manDaysLess) / Double(totalManDays)))
        }
        return CircleChartViewModel(startAngle: 0, items: circleChartItems)
    }
}
