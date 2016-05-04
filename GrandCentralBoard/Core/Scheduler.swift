//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation


/**
 Ability to schedule `Schedulable` jobs and to invalidate all scheduled jobs.
 */
public protocol SchedulingJobs {

    /**
     Schedule job - job's selector will be called with certain frequency.

     - parameter job: A class having `selector` to be called periodically (defined by `interval` property). **Will be held strongly.**
     */
    func schedule(job: Schedulable)

    /**
     Invalidate all jobs previously scheduled by calling `schedule(job:)`.
     */
    func invalidateAll()
}

/// Scheduler can schedule `Schedulable` jobs to be updated with certain frequency. I can also invalidate all previously scheduled jobs.
public final class Scheduler: SchedulingJobs {

    private var timers = [NSTimer]()

    public init() {

    }

    /**
     Schedule job - job's selector will be called with certain frequency.

     - parameter job: A class having `selector` to be called periodically (defined by `interval` property). **Will be held strongly.**
     */
    public func schedule(job: Schedulable) {
        let timer = NSTimer(fireDate: NSDate(), interval: job.interval, target: job, selector: job.selector, userInfo: nil, repeats: true)
        timers.append(timer)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
    }

    /**
     Invalidate all jobs previously scheduled by calling `schedule(job:)`.
     */
    public func invalidateAll() {

        timers.forEach { timer in
            timer.invalidate()
        }

        timers = []
    }
}
