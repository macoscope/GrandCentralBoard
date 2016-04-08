//
//  Created by Oktawian Chojnacki on 31.12.2015.
//  Copyright © 2015 Oktawian Chojnacki. All rights reserved.
//

import Foundation


public enum SourceType {
    case Cumulative
    case Momentary
}

public protocol UpdatingSource : class {
    var interval: NSTimeInterval { get }
}

public protocol Source : UpdatingSource {

    associatedtype ResultType

    var sourceType: SourceType { get }
}

/**
 The source will return value synchronously in a non-blocking way.
 */
public protocol Synchronous : Source {
    func read() -> ResultType
}

/**
 The source will call the provided block after the value is retrieved (only once).
 */
public protocol Asynchronous : Source {
    func read(closure: (ResultType) -> Void)
}

/**
 The source will call the provided block each time a new value arrives (multiple times). Note that `optimalFrequency` can and often will be ignored.
 */
public protocol Subscribable : Source {
    var subscriptionBlock: ((ResultType) -> Void)? { get set }
}