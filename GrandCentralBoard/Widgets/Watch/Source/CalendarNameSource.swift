//
//  CalendarNameSource.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 12.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import GrandCentralBoardCore

class CalendarNameSource : Asynchronous {
    typealias ResultType = Result<Calendar>

    let interval: NSTimeInterval = 3600*24
    let sourceType: SourceType = .Momentary

    func read(closure: (ResultType) -> Void) {
        fatalError("Not implemented")
    }
}
