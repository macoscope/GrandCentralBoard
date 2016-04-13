//
//  EventsSource.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 12.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import GrandCentralBoardCore

final class EventsSource : Asynchronous {
    typealias ResultType = Result<[Event]>
    let sourceType: SourceType = .Momentary

    let calendarID: String
    let interval: NSTimeInterval
    let dataProvider: CalendarDataProviding

    init(calendarID: String, dataProvider: CalendarDataProviding, refreshInterval: NSTimeInterval = 60) {
        self.calendarID = calendarID
        self.interval = refreshInterval
        self.dataProvider = dataProvider
    }

    func read(closure: (ResultType) -> Void) {
        dataProvider.fetchEventsForCalendar(calendarID) { result in
            switch result {
            case .Success(let events): closure(.Success(events))
            case .Failure(let error): closure(.Failure(error))
            }
        }
    }
}
