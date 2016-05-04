//
//  Created by Oktawian Chojnacki on 31.12.2015.
//  Copyright © 2015 Oktawian Chojnacki. All rights reserved.
//

import Foundation


/**
 Source can be:

 - Cumulative: values should cumulated (ex. website visits)
 - Momentary:  values should be presented live (ex. temperature).
 */
public enum SourceType {
    case Cumulative
    case Momentary
}

/// Updating Source has an interval that defines the time between updates.
public protocol UpdatingSource : class {
    var interval: NSTimeInterval { get }
}

/**
 The Source has associated type ResultType in form of proparty `sourceType` and inherits the `UpdatingSource` protocol.
 */
public protocol Source: UpdatingSource {

    associatedtype ResultType

    var sourceType: SourceType { get }
}

/**
 The source will return value synchronously in a non-blocking way.
 */
public protocol Synchronous: Source {
    func read() -> ResultType
}

/**
 The source will call the provided block after the value is retrieved (only once).
 */
public protocol Asynchronous: Source {
    func read(closure: (ResultType) -> Void)
}

/**
 The source will call the provided block each time a new value arrives (multiple times). Note that `optimalFrequency` can and often will be ignored.
 */
public protocol Subscribable: Source {
    var subscriptionBlock: ((ResultType) -> Void)? { get set }
}
