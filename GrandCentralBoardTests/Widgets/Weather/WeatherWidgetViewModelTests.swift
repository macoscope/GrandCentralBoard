//
//  WeatherWidgetViewModelTests.swift
//  GrandCentralBoard
//
//  Created by Joel Fischer on 6/6/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import GrandCentralBoard

class WeatherWidgetViewModelTests: FBSnapshotTestCase {

    func widgetRenderingViewModel(viewModel: WeatherViewModel) -> UIView {
        let view = WeatherWidgetView.fromNib()
        view.updateWithViewModel(viewModel)
        return view
    }

    override func setUp() {
        super.setUp()
//        recordMode = true
    }

    func testCurrentWeatherNoForecast() {
        let viewModel = WeatherViewModel(temperature: 27, windSpeed: "14 mph", icon: .CloudSun, forecast: [])

        FBSnapshotVerifyView(widgetRenderingViewModel(viewModel))
    }

    func testWeatherWithForecast() {
        let weatherForecast1 = WeatherForecastViewModel(date: "Mon", highTemperature: 32, lowTemperature: 17, icon: .Sun)
        let weatherForecast2 = WeatherForecastViewModel(date: "Tue", highTemperature: 42, lowTemperature: 12, icon: .Cloud)
        let weatherForecast3 = WeatherForecastViewModel(date: "Wed", highTemperature: 26, lowTemperature: 0, icon: .Snow)
        let weatherForecast4 = WeatherForecastViewModel(date: "Thu", highTemperature: 104, lowTemperature: -16, icon: .Downpour)

        let viewModel = WeatherViewModel(temperature: 27,
                                         windSpeed: "14 mph",
                                         icon: .CloudSun,
                                         forecast: [weatherForecast1,
                                            weatherForecast2,
                                            weatherForecast3,
                                            weatherForecast4])
        FBSnapshotVerifyView(widgetRenderingViewModel(viewModel))
    }

}
