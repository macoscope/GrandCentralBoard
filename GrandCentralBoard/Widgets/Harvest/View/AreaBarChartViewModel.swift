//
//  Created by Oktawian Chojnacki on 13.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit


enum AreaBarItemValueLabelDisplayMode {
    case Hidden
    case VisibleWithHiddenLabel
    case VisibleLabelLeft(text: String)
    case VisibleLabelRight(text: String)
}

struct AreaBarItemViewModel {
    let proportionalWidth: CGFloat // 1 is maximum
    let proportionalHeight: CGFloat // 1 is maximum
    let color: UIColor
    let valueLabelMode: AreaBarItemValueLabelDisplayMode
}

struct AreaBarChartComponentViewModel {
    let barItems: [AreaBarItemViewModel]
    let horizontalAxisCountLabelText: String
    let headerText: String?
    let subheaderText: String?
}

struct AreaBarChartViewModel {

    let mainChart: AreaBarChartComponentViewModel
    let componentCharts: [AreaBarChartComponentViewModel]

    let horizontalAxisStops: Int
    let horizontalAxisLabelText: String

    let centerText: String?

    static func emptyViewModel(header header: String? = nil, subheader: String? = nil,
                                      historicalCharts: [AreaBarChartComponentViewModel] = []) -> AreaBarChartViewModel {
        let items = [
            AreaBarItemViewModel(proportionalWidth: 0.333, proportionalHeight: 0.05, color: UIColor.lipstick(), valueLabelMode: .Hidden),
            AreaBarItemViewModel(proportionalWidth: 0.333, proportionalHeight: 0.05, color: UIColor.aquaMarine(), valueLabelMode: .Hidden),
            AreaBarItemViewModel(proportionalWidth: 0.333, proportionalHeight: 0.05, color: UIColor.almostWhite(), valueLabelMode: .Hidden)]

        let mainChart = AreaBarChartComponentViewModel(barItems: items, horizontalAxisCountLabelText: "0",
                                                       headerText: "HARVEST BURN REPORT", subheaderText: "Monday 28.03.2016")

        return AreaBarChartViewModel(mainChart: mainChart, componentCharts: historicalCharts,
                                     horizontalAxisStops: 20, horizontalAxisLabelText: "people billing:", centerText: "We didn't work yesterday")
    }
}
