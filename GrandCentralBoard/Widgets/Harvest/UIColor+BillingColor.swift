//
//  UIColor+BillingColor.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 18.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import UIKit


extension UIColor {
    static func hoursNormalColor() -> UIColor {
        return UIColor(red: 35/255, green: 208/255, blue: 165/255, alpha: 1)
    }

    static func hoursLessColor() -> UIColor {
        return UIColor(red: 210/255, green: 13/255, blue: 34/255, alpha: 1)
    }

    static func hoursMoreColor() -> UIColor {
        return UIColor(red: 246/255, green: 166/255, blue: 58/255, alpha: 1)
    }
}
