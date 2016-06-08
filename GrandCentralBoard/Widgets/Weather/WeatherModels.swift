//
//  WeatherModels.swift
//  GrandCentralBoard
//
//  Created by Joel Fischer on 4/25/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import CZWeatherKit

enum UnitType {
    case Imperial, Metric

    static func typeFromString(string: String) -> UnitType {
        if string.lowercaseString == "i" || string.lowercaseString == "imperial" {
            return .Imperial
        } else {
            return .Metric
        }
    }
}

struct WeatherModel {
    let currentWeather: CurrentWeatherModel
    let forecast: [WeatherForecastModel]
    let units: UnitType
}

struct CurrentWeatherModel {
    let currentTemperature: Int
    let windSpeed: Int
    let icon: Climacon

    init(czData: CZWeatherCurrentCondition, units: UnitType) {
        self.currentTemperature = (units == .Imperial) ? Int(czData.temperature.f) : Int(czData.temperature.c)
        self.windSpeed = (units == .Imperial) ? Int(czData.windSpeed.mph) : Int(czData.windSpeed.kph)
        self.icon = czData.climacon
    }
}

struct WeatherForecastModel {
    let highTemperature: Int
    let lowTemperature: Int
    let icon: Climacon
    let date: NSDate

    init(czForecastModel: CZWeatherForecastCondition, units: UnitType) {
        self.highTemperature = (units == .Imperial) ? Int(czForecastModel.highTemperature.f) : Int(czForecastModel.highTemperature.c)
        self.lowTemperature = (units == .Imperial) ? Int(czForecastModel.lowTemperature.f) : Int(czForecastModel.lowTemperature.c)
        self.icon = czForecastModel.climacon
        self.date = czForecastModel.date
    }
}
