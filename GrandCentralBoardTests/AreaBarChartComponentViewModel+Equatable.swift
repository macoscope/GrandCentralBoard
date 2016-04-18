//
//  AreaBarChartComponentViewModel+Equatable.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-18.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
@testable import GrandCentralBoard


extension AreaBarItemValueLabelDisplayMode : Equatable {
}


func ==(lhs: AreaBarItemValueLabelDisplayMode, rhs: AreaBarItemValueLabelDisplayMode) -> Bool {
    switch (lhs, rhs) {
    case (.Hidden, .Hidden):
        return true

    case (.VisibleWithHiddenLabel, .VisibleWithHiddenLabel):
        return true

    case (let .VisibleLabelLeft(lhsText), let .VisibleLabelLeft(rhsText)):
        return lhsText == rhsText

    case (let .VisibleLabelRight(lhsText), let .VisibleLabelRight(rhsText)):
        return lhsText == rhsText

    default:
        return false
    }
}