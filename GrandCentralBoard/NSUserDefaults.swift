//
//  Created by Oktawian Chojnacki on 14.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation

private let GCBLoadBundledConfig = "LoadBundledConfig"

extension NSUserDefaults {
    static var loadBundledConfig: Bool {
        return NSUserDefaults.standardUserDefaults().integerForKey(GCBLoadBundledConfig) > 0
    }
}