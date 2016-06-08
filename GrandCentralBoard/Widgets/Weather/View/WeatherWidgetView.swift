//
//  WeatherWidgetView.swift
//  GrandCentralBoard
//
//  Created by Joel Fischer on 4/25/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import GCBCore
import CZWeatherKit

struct WeatherViewModel {
    let temperature: Int
    let windSpeed: String // ex. 17 mph
    let icon: Climacon
    let forecast: [WeatherForecastViewModel]

    init(model: WeatherModel) {
        self.temperature = model.currentWeather.currentTemperature
        self.icon = model.currentWeather.icon
        self.forecast = model.forecast.prefix(4).map { WeatherForecastViewModel(model: $0) }

        let windUnits = (model.units == .Imperial) ? "mph" : "kph"
        self.windSpeed = "\(model.currentWeather.windSpeed) \(windUnits)"
    }

    init(temperature: Int = 0, windSpeed: String = "0 mph", icon: Climacon = .Cloud, forecast: [WeatherForecastViewModel] = []) {
        self.temperature = temperature
        self.icon = icon
        self.forecast = forecast
        self.windSpeed = windSpeed
    }
}

final class WeatherWidgetView: UIView {
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var iconLabel: UILabel!
    @IBOutlet private weak var forecastViews: UIView!
    @IBOutlet private weak var windSpeedLabel: UILabel!

    func updateWithViewModel(viewModel: WeatherViewModel) {
        self.temperatureLabel.text = "\(viewModel.temperature)°"
        self.iconLabel.text = String(Character(UnicodeScalar(Int(viewModel.icon.rawValue))))
        self.windSpeedLabel.text = "\(viewModel.windSpeed)"

        self.forecastViews.subviews.forEach { $0.removeFromSuperview() }

        var forecastViewXPosition: CGFloat = 0
        viewModel.forecast.forEach {
            let forecastView = WeatherForecastView.fromNib()
            forecastView.updateWithViewModel($0)
            forecastView.frame = CGRect(x: forecastViewXPosition, y: 0, width: 120, height: 200)
            self.forecastViews.addSubview(forecastView)

            forecastViewXPosition += 120 + 16
        }
    }

    class func fromNib() -> WeatherWidgetView {
        return NSBundle.mainBundle().loadNibNamed("WeatherWidgetView", owner: nil, options: nil)[0] as! WeatherWidgetView
    }
}
