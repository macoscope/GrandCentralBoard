//
//  Created by Oktawian Chojnacki on 11.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation


private let GCBRemoteConfigurationPathKey = "GCBRemoteConfigurationPath"
private let GCBLocalConfigurationFileNameKey = "GCBLocalConfigurationFileName"

extension NSBundle {
    static func stringForInfoDictionaryKey(key: String) -> String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey(key) as! String
    }
}

extension NSBundle {
    static var remoteConfigurationPath : String {
        return stringForInfoDictionaryKey("GCBRemoteConfigurationPath")
    }

    static var localConfigurationFileName : String {
        return stringForInfoDictionaryKey("GCBLocalConfigurationFileName")
    }
}