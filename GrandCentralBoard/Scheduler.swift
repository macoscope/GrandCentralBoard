//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation

protocol Schedulable : class {
    var interval: NSTimeInterval { get }
    var selector: Selector { get }
}

final class Job : Schedulable {

    let target: Updateable
    let selector: Selector = "update"

    init(target: Updateable) {
        self.target = target
    }

    var interval: NSTimeInterval {
        return target.interval
    }
}

protocol SchedulingJobs {
    func schedule(job: Job)
}

final class Scheduler : SchedulingJobs {

    private var timers =  [NSTimer]()

    func schedule(job: Job) {
        let timer = NSTimer(fireDate: NSDate(), interval: job.interval, target: job.target, selector: job.selector, userInfo: nil, repeats: true)
        timers.append(timer)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
    }
}