//
//  GoogleCalendarNameSource.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 12.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import GrandCentralBoardCore

final class GoogleCalendarNameSource : CalendarNameSource {

    private let dataProvider: CalendarDataProviding
    private let calendarID: String

    init(calendarID: String, dataProvider: CalendarDataProviding) {
        self.dataProvider = dataProvider
        self.calendarID = calendarID
    }

    override func read(closure: (ResultType) -> Void) {
        dataProvider.fetchCalendar(calendarID, completion: { (result) in
            switch result {
            case .Success(let calendarModel): closure(.Success(calendarModel))
            case .Failure(let error): closure(.Failure(error))
            }
        })
    }
}
