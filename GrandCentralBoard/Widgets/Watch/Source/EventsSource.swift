//
//  EventsSource.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 12.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import GrandCentralBoardCore

class EventsSource : Asynchronous {
    typealias ResultType = Result<[Event]>

    let interval: NSTimeInterval = 60
    let sourceType: SourceType = .Momentary

    func read(closure: (ResultType) -> Void) {
        fatalError("Not implemented")
    }
}
