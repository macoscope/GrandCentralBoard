//
//  WeatherForecastView.swift
//  GrandCentralBoard
//
//  Created by Joel Fischer on 4/26/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import GCBCore
import CZWeatherKit

struct WeatherForecastViewModel {
    let date: String
    let highTemperature: Int
    let lowTemperature: Int
    let icon: Climacon

    init(model: WeatherForecastModel) {
        let date = WeatherForecastModel.forceMidnightDate(model.date)

        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = "EE"

        self.date = dateFormatter.stringFromDate(date)
        self.highTemperature = model.highTemperature
        self.lowTemperature = model.lowTemperature
        self.icon = model.icon
    }

    init(date: String = "Mon", highTemperature: Int = 74, lowTemperature: Int = 57, icon: Climacon = .Cloud) {
        self.date = date
        self.highTemperature = highTemperature
        self.lowTemperature = lowTemperature
        self.icon = icon
    }
}

extension WeatherForecastModel {
    private static func forceMidnightDate(date: NSDate) -> NSDate {
        // HAX: There's a bug here where the api will return the previous day as the date, at 11:58 p.m., we need to work around it
        let fixedDate: NSDate
        let dateComponents = NSCalendar.currentCalendar().components([.Minute], fromDate: date)
        if dateComponents.minute == 58 {
            let oneDayComponent = NSDateComponents()
            oneDayComponent.day = 1
            fixedDate = NSCalendar.currentCalendar().dateByAddingComponents(oneDayComponent, toDate: date, options: [])!
        } else {
            fixedDate = date
        }

        return fixedDate
    }
}

final class WeatherForecastView: UIView {
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var highTempLabel: UILabel!
    @IBOutlet private weak var lowTempLabel: UILabel!
    @IBOutlet private weak var iconLabel: UILabel!

    func updateWithViewModel(viewModel: WeatherForecastViewModel) {
        dayLabel.text = viewModel.date
        highTempLabel.text = "\(viewModel.highTemperature)°"
        lowTempLabel.text = "\(viewModel.lowTemperature)°"
        iconLabel.text = String(Character(UnicodeScalar(Int(viewModel.icon.rawValue))))
    }

    class func fromNib() -> WeatherForecastView {
        return NSBundle.mainBundle().loadNibNamed("WeatherForecastView", owner: nil, options: nil)[0] as! WeatherForecastView
    }

}
