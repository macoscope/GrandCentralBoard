//
//  BonusSource.swift
//  GrandCentralBoard
//
//  Created by krris on 25/02/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation

final class BonusSource : Synchronous {
    
    typealias ResultType = Result<[Person]>

    let sourceType: SourceType = .Momentary
    let interval: NSTimeInterval = 1

    func read() -> ResultType {
        return .Success(randomlyUpdateData(sampleData))
    }
}
