//
//  NSBundle.swift
//  Pods
//
//  Created by Maciek Grzybowski on 18.05.2016.
//
//

import Foundation


internal extension NSBundle {

    class func resourcesBundle() -> NSBundle {
        let mainBundle = NSBundle(forClass: GrandCentralBoardController.self)
        let resourcesBundleURL = mainBundle.URLForResource("GCBCore", withExtension: "bundle")!
        return NSBundle(URL: resourcesBundleURL)!

    }
}
