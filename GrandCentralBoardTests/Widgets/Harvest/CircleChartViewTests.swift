//
//  CircleChartViewTests.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 17.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import FBSnapshotTestCase
@testable import GrandCentralBoard


final class CircleChartViewTests: FBSnapshotTestCase {

    private var circleChart: CircleChart!

    override func setUp() {
        super.setUp()
        circleChart = CircleChart(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        circleChart.strokeWidth = 30
    }

    func testEvenDistribution() {
        let items = [
            CircleChartItem(color: .redColor(), ratio: 1.0 / 3),
            CircleChartItem(color: .greenColor(), ratio: 1.0 / 3),
            CircleChartItem(color: .blueColor(), ratio: 1.0 / 3)
        ]
        circleChart.configureWithViewModel(CircleChartViewModel(startAngle: 0, items: items))
        circleChart.frame = CGRect(x: 0, y: 0, width: 200, height: 200)

        FBSnapshotVerifyView(circleChart)
    }

    func testEvenDistribution180StartAngle() {
        let items = [
            CircleChartItem(color: .redColor(), ratio: 1.0 / 3),
            CircleChartItem(color: .greenColor(), ratio: 1.0 / 3),
            CircleChartItem(color: .blueColor(), ratio: 1.0 / 3)
        ]
        circleChart.configureWithViewModel(CircleChartViewModel(startAngle: M_PI, items: items))
        circleChart.frame = CGRect(x: 0, y: 0, width: 200, height: 200)

        FBSnapshotVerifyView(circleChart)
    }

    func testTwoShortItemsAtTheBeginning() {
        let items = [
            CircleChartItem(color: .redColor(), ratio: 0.02),
            CircleChartItem(color: .greenColor(), ratio: 0.02),
            CircleChartItem(color: .blueColor(), ratio: 0.96)
        ]
        circleChart.configureWithViewModel(CircleChartViewModel(startAngle: 0, items: items))
        circleChart.frame = CGRect(x: 0, y: 0, width: 200, height: 200)

        FBSnapshotVerifyView(circleChart)
    }

    func testTwoShortItemsAtTheEnd() {
        let items = [
            CircleChartItem(color: .redColor(), ratio: 0.96),
            CircleChartItem(color: .greenColor(), ratio: 0.02),
            CircleChartItem(color: .blueColor(), ratio: 0.02)
        ]
        circleChart.configureWithViewModel(CircleChartViewModel(startAngle: 0, items: items))
        circleChart.frame = CGRect(x: 0, y: 0, width: 200, height: 200)

        FBSnapshotVerifyView(circleChart)
    }

    func testItemsNotNormalized() {
        let items = [
            CircleChartItem(color: .redColor(), ratio: 2.3),
            CircleChartItem(color: .greenColor(), ratio: 2.3),
            CircleChartItem(color: .blueColor(), ratio: 2.3)
        ]
        circleChart.configureWithViewModel(CircleChartViewModel(startAngle: 0, items: items))
        circleChart.frame = CGRect(x: 0, y: 0, width: 200, height: 200)

        FBSnapshotVerifyView(circleChart)
    }
}
