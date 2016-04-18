//
//  Created by Oktawian Chojnacki on 18.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation


private let loadBundledConfigKey = "LoadBundledConfig"

extension NSProcessInfo {
    static var loadBundledConfig: Bool {

        let environment = NSProcessInfo.processInfo().environment

        if let mode = environment[loadBundledConfigKey] {
            return mode == "true"
        }

        return false
    }
}

