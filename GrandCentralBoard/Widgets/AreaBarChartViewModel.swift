//
//  Created by Oktawian Chojnacki on 13.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit


enum AreaBarItemValueLabelDisplayMode {
    case Hidden
    case Left(text: String)
    case Right(text: String)
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
}