//
//  Created by Oktawian Chojnacki on 31.12.2015.
//  Copyright © 2015 Oktawian Chojnacki. All rights reserved.
//

import Foundation

enum SourceType: Int {
    case Cumulative
    case Momentary
}

enum Result<T> {
    case Failure
    case Success(T)
}

protocol Source {

    typealias ResultType

    var sourceType: SourceType { get }
    var optimalFrequency: NSTimeInterval { get }
}

protocol Synchronous : Source {
    func read() -> ResultType
}

protocol Asynchronous : Source {
    func read(closure: (ResultType) -> Void)
}