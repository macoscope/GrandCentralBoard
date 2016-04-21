//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation


public protocol Schedulable : class {
    var interval: NSTimeInterval { get }
    var selector: Selector { get }
    var source: UpdatingSource { get }
    var target: Updateable { get }
}

public final class Job: Schedulable {

    public let target: Updateable
    public let selector: Selector = "update"
    public let source: UpdatingSource

    public init(target: Updateable, source: UpdatingSource) {
        self.target = target
        self.source = source
    }

    public var interval: NSTimeInterval {
        return source.interval
    }

    // This selector is called by NSTimer initiated in Scheduler `schedule` method.
    @objc func update() {
        target.update(source)
    }
}

public protocol SchedulingJobs {
    func schedule(job: Schedulable)
    func invalidateAll()
}

public final class Scheduler: SchedulingJobs {

    private var timers = [NSTimer]()

    public init() {

    }

    public func schedule(job: Schedulable) {
        let timer = NSTimer(fireDate: NSDate(), interval: job.interval, target: job, selector: job.selector, userInfo: nil, repeats: true)
        timers.append(timer)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
    }

    public func invalidateAll() {

        timers.forEach { timer in
            timer.invalidate()
        }

        timers = []
    }
}
