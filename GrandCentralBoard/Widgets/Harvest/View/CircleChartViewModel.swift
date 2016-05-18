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
