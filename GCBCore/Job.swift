//
//  Created by Oktawian Chojnacki on 23.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation


/**
 Have read only `source` property, having information about `interval` between which the `source` should be updated.
 */
public protocol HavingSource {
    var source: UpdatingSource { get }
}

/**
 Have read only `target` property conforming to `Updateable` protocol. Target be updated by source.
 */
public protocol HavingTarget {
    var target: Updateable { get }
}

/**
 Selector specified in `selector` property will be called periodically. The period length is specified by `interval` property.
 */
public protocol Schedulable : class {

    /// This property defines the period length between the calls to `selector`.
    var interval: NSTimeInterval { get }

    /// This selector will be called periodically
    var selector: Selector { get }
}
/**
 This class have `source` and `target`.

 Target is updated from the source when `update()` method is called.

 The `update()` method is called periodically. The period length is specified by `interval` property.
 */
public final class Job: Schedulable, HavingSource, HavingTarget {

    public let target: Updateable
    public let selector: Selector = #selector(update)
    public let source: UpdatingSource

    public init(target: Updateable, source: UpdatingSource) {
        self.target = target
        self.source = source
    }

    /// This property specifies the period between which the `source` should be updated.
    public var interval: NSTimeInterval {
        return source.interval
    }

    /// This selector is called by NSTimer initiated in Scheduler `schedule` method.
    @objc func update() {
        target.update(source)
    }
}
