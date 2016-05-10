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

    let emptyComponentViewModel = AreaBarChartComponentViewModel(barItems: [], horizontalAxisCountLabelText: "", headerText: "", subheaderText: "")

    func testHeaderForNoHistoricalData() {
        let viewModel = AreaBarChartViewModel(mainChart: emptyComponentViewModel, componentCharts: [],
                                              horizontalAxisStops: 20, centerText: "")
        expect(viewModel.historicalHeaderText) == "Previous 0 Days".uppercaseString
    }

    func testHeaderForOneHistoricalDay() {
        let viewModel = AreaBarChartViewModel(mainChart: emptyComponentViewModel, componentCharts: [emptyComponentViewModel],
                                          horizontalAxisStops: 20, centerText: "")
        expect(viewModel.historicalHeaderText) == "Previous Day".uppercaseString
    }

    func testHeaderForTwoAndMoreHistoricalDays() {
        for numberOfDays in 2...5 {
            var componentCharts = [AreaBarChartComponentViewModel]()
            for _ in 1...numberOfDays { componentCharts.append(emptyComponentViewModel) }

            let viewModel = AreaBarChartViewModel(mainChart: emptyComponentViewModel, componentCharts: componentCharts,
                                              horizontalAxisStops: 20, centerText: "")
            expect(viewModel.historicalHeaderText) == "Previous \(numberOfDays) Days".uppercaseString
        }
    }
}
