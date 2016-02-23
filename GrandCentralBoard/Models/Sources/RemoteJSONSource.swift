//
//  Created by Oktawian Chojnacki on 31.12.2015.
//  Copyright © 2015 Oktawian Chojnacki. All rights reserved.
//

import Foundation

final class RemoteJSONSource : Asynchronous {

    typealias ResultType = Result<Number>

    let optimalFrequency: NSTimeInterval = 10

    func read(closure: (ResultType) -> Void) {

        // TODO: REQUEST

        closure(.Success(Number(value: 1000, time: nil)))
    }

    var sourceType: SourceType = .Momentary
}
