//
//
//  Created by Krzysztof Werys on 09/03/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import Foundation

extension NSDate: Comparable { }

public func == (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func < (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

public func > (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedDescending
}

public func <= (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs == rhs || lhs.compare(rhs) == .OrderedAscending
}

public func >= (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs == rhs || lhs.compare(rhs) == .OrderedDescending
}
