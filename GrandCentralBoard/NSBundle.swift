//
//  Created by Oktawian Chojnacki on 11.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation


private let GCBRemoteConfigurationPathKey = "GCBRemoteConfigurationPath"
private let GCBLocalConfigurationFileNameKey = "GCBLocalConfigurationFileName"
private let GCBAlwaysUseLocalConfigurationFileKey = "GCBAlwaysUseLocalConfigurationFile"

extension NSBundle {
    static func stringForInfoDictionaryKey(key: String) -> String? {
        return NSBundle.mainBundle().objectForInfoDictionaryKey(key) as? String
    }

    static func boolForInfoDictionaryKey(key: String) -> Bool? {

        if let number =  NSBundle.mainBundle().objectForInfoDictionaryKey(key) as? NSNumber {
            return number.boolValue
        }

        return nil
    }
}

extension NSBundle {

    static var alwaysUseLocalConfigurationFile: Bool {
        return boolForInfoDictionaryKey(GCBAlwaysUseLocalConfigurationFileKey)!
    }

    static var remoteConfigurationPath: String {
        return stringForInfoDictionaryKey(GCBRemoteConfigurationPathKey)!
    }

    static var localConfigurationFileName: String {
        return stringForInfoDictionaryKey(GCBLocalConfigurationFileNameKey)!
    }
}
