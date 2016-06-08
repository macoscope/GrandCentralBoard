//
//  WeatherSource.swift
//  GrandCentralBoard
//
//  Created by Joel Fischer on 4/25/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import GCBCore
import CZWeatherKit

enum WeatherSourceError: ErrorType, HavingMessage {
    case CZWeatherKitError(NSError)
    case NoDataError

    var message: String {
        switch self {
        case .CZWeatherKitError(let error):
            return NSLocalizedString("Weather API returned an error: \(error)", comment: "")
        case .NoDataError():
            return NSLocalizedString("Weather API returned no data, unknown error", comment: "")
        }
    }
}

final class WeatherSource: Asynchronous {
    typealias ResultType = Result<WeatherModel>

    let interval: NSTimeInterval
    let sourceType: SourceType = .Momentary

    private let settings: WeatherSettings
    private var model: WeatherModel?
    private var location: CLLocation? = nil

    init(settings: WeatherSettings, interval: NSTimeInterval = 900) {
        self.settings = settings
        self.interval = interval

        self.location = CLLocation(latitude: Double(settings.latLon[0])!, longitude: Double(settings.latLon[1])!)
    }

    func read(closure: (ResultType) -> Void) {
        let request = CZForecastioRequest.newForecastRequest()
        request.location = CZWeatherLocation(fromLocation: self.location)
        request.key = settings.apiKey
        request.sendWithCompletion { (data, error) in

            let units = UnitType.typeFromString(self.settings.units)

            guard let weatherData = data else {
                closure(.Failure(WeatherSourceError.NoDataError))
                return
            }

            // Capture the current weather model
            let currentWeather = CurrentWeatherModel(czData: weatherData.current, units: units)

            // Capture the forecast model
            var dailyForecasts: [WeatherForecastModel] = []
            for forecast in weatherData.dailyForecasts {
                guard let forecast = forecast as? CZWeatherForecastCondition else {
                    continue
                }

                dailyForecasts.append(WeatherForecastModel(czForecastModel: forecast, units: units))
            }

            closure(.Success(WeatherModel(currentWeather: currentWeather, forecast: dailyForecasts, units: units)))
        }
    }
}
