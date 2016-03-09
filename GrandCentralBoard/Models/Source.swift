//
//  Created by Oktawian Chojnacki on 31.12.2015.
//  Copyright © 2015 Oktawian Chojnacki. All rights reserved.
//

import Foundation

enum SourceType {
    case Cumulative
    case Momentary
}

protocol UpdatingSource : class {
    var interval: NSTimeInterval { get }
}

protocol Source : UpdatingSource {

    typealias ResultType

    var sourceType: SourceType { get }
}

protocol Synchronous : Source {
    func read() -> ResultType
}

protocol Asynchronous : Source {
    func read(closure: (ResultType) -> Void)
}