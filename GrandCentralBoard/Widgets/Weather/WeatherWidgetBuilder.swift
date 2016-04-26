//
//  WeatherWidgetBuilder.swift
//  GrandCentralBoard
//
//  Created by Joel Fischer on 4/25/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import Decodable
import GCBCore

final class WeatherWidgetBuilder: WidgetBuilding {
    let name = "weather"

    func build(settings: AnyObject) throws -> WidgetControlling {
        let weatherSettings = try WeatherSettings.decode(settings)
        let weatherSource = WeatherSource(settings: weatherSettings)

        let view = WeatherWidgetView.fromNib()

        return WeatherWidget(view: view, sources: [weatherSource])
    }
}

/**
 *  The pattern for weather settings is generally:
 *  { "name": "weather",
 *    "settings": {
 *                  "apiKey": "Forecast.io api key",
 *                  "units": "i" = imperial, "m" = metric (default)
 *                  "latlon": ["latitude", "longitude"]
 */
struct WeatherSettings: Decodable {
    let apiKey: String
    let units: String // "i", "imperial", "m", "metric", defaults to metric
    let latLon: [String]

    static func decode(json: AnyObject) throws -> WeatherSettings {
        return try WeatherSettings(apiKey: json => "apiKey",
                                   units: json => "units",
                                   latLon: json => "latlon")
    }
}
