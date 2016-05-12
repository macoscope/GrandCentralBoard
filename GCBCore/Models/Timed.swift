//
//  Created by Oktawian Chojnacki on 31.12.2015.
//  Copyright © 2015 Oktawian Chojnacki. All rights reserved.
//

import Foundation

/**
 The entity implementing the protocol is timed (ex. value can represent state in given point in time).
 */
public protocol Timed {
    var time: NSDate { get }
}
