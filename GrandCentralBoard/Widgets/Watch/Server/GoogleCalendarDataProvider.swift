//
//  GoogleCalendarDataProvider.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 07.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
import Result

protocol CalendarDataProvider {
    func fetchEventsForCalendar(calendarID: String, completion: (Result<[EventModel], APIDataError>) -> Void)
    func fetchCalendar(calendarID: String, completion: (Result<CalendarModel, APIDataError>) -> Void)
}

final class GoogleCalendarDataProvider : CalendarDataProvider {

    let dataProvider: GoogleAPIDataProvider

    init(dataProvider: GoogleAPIDataProvider) {
        self.dataProvider = dataProvider
    }

    func fetchEventsForCalendar(calendarID: String, completion: (Result<[EventModel], APIDataError>) -> Void) {
        let escapedCalendarID = calendarID.URLEscape()
        let url = NSURL(string: "https://www.googleapis.com/calendar/v3/calendars/\(escapedCalendarID)/events")!
        let parameters = ["maxResults" : 10, "orderyBy" : "startTime", "singleEvents" : "true"]

        dataProvider.request(.GET, url: url, parameters: parameters) { result in
            switch result {
            case .Failure(let error):
                completion(.Failure(error))
            case .Success(let json):
                do {
                    let events = try EventModel.decodeArray(json)
                    completion(.Success(events))
                } catch {
                    completion(.Failure(.ModelDecodeError(error)))
                }
            }
        }
    }

    func fetchCalendar(calendarID: String, completion: (Result<CalendarModel, APIDataError>) -> Void) {
        let escapedCalendarID = calendarID.URLEscape()
        let url = NSURL(string: "https://www.googleapis.com/calendar/v3/calendars/\(escapedCalendarID)/events")!

        dataProvider.request(.GET, url: url, parameters: nil) { result in
            switch result {
            case .Failure(let error):
                completion(.Failure(error))
            case .Success(let json):
                do {
                    let model = try CalendarModel.decode(json)
                    completion(.Success(model))
                } catch {
                    completion(.Failure(.ModelDecodeError(error)))
                }
            }
        }
    }
}
