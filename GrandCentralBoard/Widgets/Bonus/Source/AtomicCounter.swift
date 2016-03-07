//
//  File.swift
//  GrandCentralBoard
//
//  Created by krris on 08/03/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation

class AtomicCounter {
    private var queue = dispatch_queue_create("atomic.counter.queue.", DISPATCH_QUEUE_SERIAL)
    private (set) var value: Int = 0
    
    func increment() {
        dispatch_sync(queue, {
            self.value += 1
        })
    }
}
