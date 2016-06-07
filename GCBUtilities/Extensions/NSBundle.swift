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
        let mainBundle = NSBundle(forClass: WidgetTemplateView.self)
        let resourcesBundleURL = mainBundle.URLForResource("GCBUtilities", withExtension: "bundle")!
        return NSBundle(URL: resourcesBundleURL)!

    }
}
