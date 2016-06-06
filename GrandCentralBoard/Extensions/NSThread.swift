//
//  NSThread.swift
//  GrandCentralBoard
//
//  Created by Maciek Grzybowski on 24.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import Foundation


extension NSThread {
    static func runOnMainThread(block: ()->()) {
        if NSThread.isMainThread() {
            block()
            return
        }

        dispatch_async(dispatch_get_main_queue(), block)
    }
}
