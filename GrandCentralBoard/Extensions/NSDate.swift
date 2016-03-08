//
//
//  Created by Krzysztof Werys on 09/03/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import Foundation

extension NSDate {
    func isGreaterThanDate(date: NSDate) -> Bool {
        return self.compare(date) == NSComparisonResult.OrderedDescending
    }
    
    func isLessThanDate(date: NSDate) -> Bool {
        return self.compare(date) == NSComparisonResult.OrderedAscending
    }
}
