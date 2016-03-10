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

    typealias ResultType

    var sourceType: SourceType { get }
}

public protocol Synchronous : Source {
    func read() -> ResultType
}

public protocol Asynchronous : Source {
    func read(closure: (ResultType) -> Void)
}