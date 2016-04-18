//
//  AreaBarChartComponentViewModel+FromDailyBillingStats.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-18.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit


extension AreaBarChartComponentViewModel {
    static func viewModelFromDailyBillingStats(dailyBillingStats: DailyBillingStats, isMainChart: Bool = true) -> AreaBarChartComponentViewModel? {
        guard dailyBillingStats.groups.count == 3 && totalCountForGroups(dailyBillingStats.groups) > 0 else {
            return nil
        }

        let indexes = 0...2
        let groups = dailyBillingStats.groups
        let colors = [UIColor.lipstick(), UIColor.aquaMarine(), UIColor.almostWhite()]

        let items = indexes.flatMap { index -> AreaBarItemViewModel? in
            let group = groups[index]
            let color = colors[index]
            let width = widthForGroup(group, groups: groups)
            let height = heightForGroup(group, groups: groups)
            let valueLabelMode = valueLabelModeForGroup(group, groups: groups)

            if (width > 0) {
                return AreaBarItemViewModel(proportionalWidth: width, proportionalHeight: height, color: color, valueLabelMode: valueLabelMode)

            } else {
                return nil
            }
        }

        let countLabelText = countLabelTextForDailyBillingStats(dailyBillingStats, isMainChart: isMainChart)
        let headerText = headerTextForDailyBillingStats(dailyBillingStats, isMainChart: isMainChart)
        let subheaderText = subheaderTextForDailyBillingStats(dailyBillingStats, isMainChart: isMainChart)

        return AreaBarChartComponentViewModel(barItems: items, horizontalAxisCountLabelText: countLabelText, headerText: headerText, subheaderText: subheaderText)
    }

    private static func widthForGroup(group: BillingStatsGroup, groups: [BillingStatsGroup]) -> CGFloat {
        let count = group.count
        let totalCount = totalCountForGroups(groups)

        return CGFloat(count) / CGFloat(totalCount)
    }

    private static var minHours: Double {
        return 3.0
    }

    private static var maxHours: Double {
        return 8.0
    }

    private static func heightForGroup(group: BillingStatsGroup, groups: [BillingStatsGroup]) -> CGFloat {
        let hours = max(minHours, min(maxHours, group.averageHours))

        return CGFloat(hours / maxHours)
    }

    private static func hoursText(hours: Double) -> String {
        if (hours > maxHours) {
            return String(format: "more than %@!".localized, maxHours.formattedString)

        } else if (hours < minHours) {
            return String(format: "less than %@!".localized, minHours.formattedString)

        } else {
            return hours.formattedString
        }
    }

    private static func valueLabelModeForGroup(group: BillingStatsGroup, groups: [BillingStatsGroup]) -> AreaBarItemValueLabelDisplayMode {
        let text = hoursText(group.averageHours)

        switch group.type {
        case .Less:
            return .VisibleLabelLeft(text: text)
        case .Normal:
            return .VisibleWithHiddenLabel
        case .More:
            return .VisibleLabelRight(text: text)
        }
    }

    private static func countLabelTextForDailyBillingStats(dailyBillingStats: DailyBillingStats, isMainChart: Bool) -> String {
        let totalCount = totalCountForGroups(dailyBillingStats.groups)

        return String(totalCount)
    }

    private static func headerTextForDailyBillingStats(dailyBillingStats: DailyBillingStats, isMainChart: Bool) -> String {
        if (isMainChart) {
            return "HARVEST BURN REPORT".localized

        } else {
            return dailyBillingStats.day.stringWithFormat("EEE")
        }
    }

    private static func subheaderTextForDailyBillingStats(dailyBillingStats: DailyBillingStats, isMainChart: Bool) -> String {
        if (isMainChart) {
            return dailyBillingStats.day.stringWithFormat("EEEE dd.MM.yyyy")

        } else {
            return dailyBillingStats.day.stringWithFormat("dd.MM.yyyy")
        }
    }

    private static func totalCountForGroups(groups: [BillingStatsGroup]) -> Int {
        return groups.reduce(0) { (count, group) in
            return count + group.count
        }
    }
}


extension Double {
    var formattedString: String {
        let intValue = Int(self)
        let isInteger = Double(intValue) == self

        if isInteger {
            return String(intValue)

        } else {
            return String(format: "%0.1f", self)
        }
    }
}
