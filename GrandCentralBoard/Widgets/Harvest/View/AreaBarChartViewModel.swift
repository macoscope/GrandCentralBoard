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

struct AreaBarChartViewModel {
    let barItems: [AreaBarItemViewModel]
    let horizontalAxisStops: Int
    let horizontalAxisLabelText: String
    let hotizontalAxisCountLabelText: String
    let centerText: String?
    let headerText: String?
    let subheaderText: String?

    static func emptyViewModel(header header: String? = nil, subheader: String? = nil) -> AreaBarChartViewModel {
        let items = [
            AreaBarItemViewModel(proportionalWidth: 0.333, proportionalHeight: 0.05, color: UIColor.lipstick(), valueLabelMode: .Hidden),
            AreaBarItemViewModel(proportionalWidth: 0.333, proportionalHeight: 0.05, color: UIColor.aquaMarine(), valueLabelMode: .Hidden),
            AreaBarItemViewModel(proportionalWidth: 0.333, proportionalHeight: 0.05, color: UIColor.almostWhite(), valueLabelMode: .Hidden)]

        return AreaBarChartViewModel(barItems: items, horizontalAxisStops: 20, horizontalAxisLabelText: "people billing:", hotizontalAxisCountLabelText: "0", centerText: "We didn't work yesterday", headerText: header, subheaderText: subheader)
    }
}