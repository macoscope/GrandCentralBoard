//
//  Created by Oktawian Chojnacki on 31.12.2015.
//  Copyright © 2015 Oktawian Chojnacki. All rights reserved.
//

import UIKit

protocol Timed {
    var time: NSDate? { get }
}

protocol FormattableToString {
    func format(numberStyle nstyle: NSNumberFormatterStyle) -> String
}

struct Number : Timed {
    let value: NSNumber
    let time: NSDate?
}

struct XY : Timed {
    let valueX: NSNumber
    let valueY: NSNumber
    let time: NSDate?
}

extension NSNumber : FormattableToString {
    func format(numberStyle nstyle: NSNumberFormatterStyle) -> String {
        return NSNumberFormatter.localizedStringFromNumber(self, numberStyle: nstyle)
    }
}

struct Textual : Timed {
    let value: String
    let time: NSDate?
}