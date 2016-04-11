//
//  GoogleCalendarDataProvider.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 07.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
import Result

protocol CalendarDataProviding {
    func fetchEventsForCalendar(calendarID: String, completion: (Result<[EventModel], APIDataError>) -> Void)
    func fetchCalendar(calendarID: String, completion: (Result<CalendarModel, APIDataError>) -> Void)
}

final class GoogleCalendarDataProvider : CalendarDataProviding {

    let dataProvider: APIDataProviding

    init(dataProvider: APIDataProviding) {
        self.dataProvider = dataProvider
    }

    private static let dateFormatter: NSDateFormatter =  {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ";
        return formatter
    }()

    func fetchEventsForCalendar(calendarID: String, completion: (Result<[EventModel], APIDataError>) -> Void) {
        guard let escapedCalendarID = calendarID.URLEscape() else {
            assertionFailure("Failure escaping calendar id: \(calendarID)")
            return
        }
        let url = NSURL(string: "https://www.googleapis.com/calendar/v3/calendars/\(escapedCalendarID)/events")!
        let timeMin = self.dynamicType.dateFormatter.stringFromDate(NSDate())
        let parameters: [String : AnyObject] = ["maxResults" : 10, "orderyBy" : "startTime",
                                                "singleEvents" : "true", "maxAttendees" : 1,
                                                "timeMin" : timeMin]

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
        guard let escapedCalendarID = calendarID.URLEscape() else {
            assertionFailure("Failure escaping calendar id: \(calendarID)")
            return
        }
        let url = NSURL(string: "https://www.googleapis.com/calendar/v3/calendars/\(escapedCalendarID)")!

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
