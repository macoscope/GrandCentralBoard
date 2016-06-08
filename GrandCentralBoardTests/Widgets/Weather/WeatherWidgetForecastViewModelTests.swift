//
//  WeatherWidgetForecastViewModelTests.swift
//  GrandCentralBoard
//
//  Created by Joel Fischer on 6/6/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import GrandCentralBoard

class WeatherWidgetForecastViewModelTests: FBSnapshotTestCase {

    static func widgetRenderingViewModel(viewModel: WeatherForecastViewModel) -> UIView {
        let view = WeatherForecastView.fromNib()
        view.updateWithViewModel(viewModel)
        return view
    }

    override func setUp() {
        super.setUp()
//        recordMode = true
    }

    func testWeatherForecastView() {
        let viewModel = WeatherForecastViewModel(date: "Mon", highTemperature: 56, lowTemperature: 55, icon: .Tornado)

        FBSnapshotVerifyView(WeatherWidgetForecastViewModelTests.widgetRenderingViewModel(viewModel))
    }

    func testWeatherForecastViewWithNegativeNums() {
        let viewModel = WeatherForecastViewModel(date: "Mon", highTemperature: -1, lowTemperature: -12, icon: .Snowflake)

        FBSnapshotVerifyView(WeatherWidgetForecastViewModelTests.widgetRenderingViewModel(viewModel))
    }

    func testWeatherForecastViewWith3DigitNums() {
        let viewModel = WeatherForecastViewModel(date: "Mon", highTemperature: 105, lowTemperature: 102, icon: .Sleet)

        FBSnapshotVerifyView(WeatherWidgetForecastViewModelTests.widgetRenderingViewModel(viewModel))
    }

}
