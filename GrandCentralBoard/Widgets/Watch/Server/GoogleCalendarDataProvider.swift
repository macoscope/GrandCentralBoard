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
    func fetchEventsForCalendar(calendarID: String, completion: (Result<[Event], APIDataError>) -> Void)
    func fetchCalendar(calendarID: String, completion: (Result<Calendar, APIDataError>) -> Void)
}

private enum CalendarAPIAction : String {
    case GetDetails = ""
    case GetEvents  = "events"

    static private let baseURL = NSURL(string: "https://www.googleapis.com/calendar/v3/calendars/")!

    func URLForCalendar(calendarID: String) -> NSURL? {
        guard let escapedCalendarID = calendarID.URLEscape() else {
            assertionFailure("Failure escaping calendar id: \(calendarID)")
            return nil
        }
        return self.dynamicType.baseURL.URLByAppendingPathComponent("\(escapedCalendarID)/\(self.rawValue)")
    }
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


    func fetchEventsForCalendar(calendarID: String, completion: (Result<[Event], APIDataError>) -> Void) {
                let timeMin = self.dynamicType.dateFormatter.stringFromDate(NSDate())
        guard let url = CalendarAPIAction.GetEvents.URLForCalendar(calendarID) else {
            completion(.Failure(.IncorrectRequestParameters))
            return
        }

        // maxAttendees = 1, because it is a minimal allowed value and we are not interested in
        // attendees
        let parameters: [String : AnyObject] = ["maxResults" : 10, "orderBy" : "startTime",
                                                "singleEvents" : "true", "maxAttendees" : 1,
                                                "timeMin" : timeMin]

        dataProvider.request(.GET, url: url, parameters: parameters) { result in
            switch result {
            case .Failure(let error):
                completion(.Failure(error))
            case .Success(let json):
                do {
                    let events = try Event.decodeArray(json)
                    completion(.Success(events))
                } catch {
                    completion(.Failure(.ModelDecodeError(error)))
                }
            }
        }
    }

    func fetchCalendar(calendarID: String, completion: (Result<Calendar, APIDataError>) -> Void) {
        guard let url = CalendarAPIAction.GetDetails.URLForCalendar(calendarID) else {
            completion(.Failure(.IncorrectRequestParameters))
            return
        }

        dataProvider.request(.GET, url: url, parameters: nil) { result in
            switch result {
            case .Failure(let error):
                completion(.Failure(error))
            case .Success(let json):
                do {
                    let model = try Calendar.decode(json)
                    completion(.Success(model))
                } catch {
                    completion(.Failure(.ModelDecodeError(error)))
                }
            }
        }
    }
}
