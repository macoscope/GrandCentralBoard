//
//  AreBarChartViewModelTests.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 06.05.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import XCTest
import Nimble
@testable import GrandCentralBoard


final class AreBarChartViewModelTests: XCTestCase {

    func testHeaderForPreviousDay() {
        let mainChartViewModel = AreaBarChartComponentViewModel(barItems: [], horizontalAxisCountLabelText: "", headerText: "", subheaderText: "")
        var viewModel = AreaBarChartViewModel(mainChart: mainChartViewModel, componentCharts: [],
                                              horizontalAxisStops: 20, centerText: "")
        expect(viewModel.historicalHeaderText) == "PREVIOUS 0 DAYS"

        viewModel = AreaBarChartViewModel(mainChart: mainChartViewModel, componentCharts: [mainChartViewModel],
                                          horizontalAxisStops: 20, centerText: "")
        expect(viewModel.historicalHeaderText) == "PREVIOUS 1 DAY"

        for numberOfDays in 2...5 {
            var componentCharts = [AreaBarChartComponentViewModel]()
            for _ in 1...numberOfDays { componentCharts.append(mainChartViewModel) }

            viewModel = AreaBarChartViewModel(mainChart: mainChartViewModel, componentCharts: componentCharts,
                                              horizontalAxisStops: 20, centerText: "")
            expect(viewModel.historicalHeaderText) == "PREVIOUS \(numberOfDays) DAYS"
        }

    }
}
