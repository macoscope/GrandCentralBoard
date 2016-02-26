//
//  Created by Krzysztof Werys on 25/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import Foundation

final class BonusSource : Synchronous {
    
    typealias ResultType = Result<[Person]>

    let sourceType: SourceType = .Momentary
    let interval: NSTimeInterval = 5

    func read() -> ResultType {
        return .Success(randomlyUpdateData(sampleData))
    }
}
