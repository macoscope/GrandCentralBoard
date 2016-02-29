//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation

protocol Schedulable : class {
    var interval: NSTimeInterval { get }
    var selector: Selector { get }
    var source: UpdatingSource { get }
    var target: Updateable { get }
}

final class Job : Schedulable {

    let target: Updateable
    let selector: Selector = "update:"
    let source: UpdatingSource

    init(target: Updateable, source: UpdatingSource) {
        self.target = target
        self.source = source
    }

    var interval: NSTimeInterval {
        return source.interval
    }
}

protocol SchedulingJobs {
    func schedule(job: Job)
}

final class Scheduler : SchedulingJobs {

    private var timers =  [NSTimer]()

    func schedule(job: Job) {
        let timer = NSTimer(fireDate: NSDate(), interval: job.interval, target: job.target, selector: job.selector, userInfo: job.source, repeats: true)
        timers.append(timer)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
    }
}