//
//  Created by Oktawian Chojnacki on 31.12.2015.
//  Copyright © 2015 Oktawian Chojnacki. All rights reserved.
//

import UIKit

let debugBuild: Bool = _isDebugAssertConfiguration()
let configurationPath = "http://localhost:8000/configuration.json"
let localConfigurationFileName = "configuration"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        UIApplication.sharedApplication().idleTimerDisabled = true

        return true
    }
}

