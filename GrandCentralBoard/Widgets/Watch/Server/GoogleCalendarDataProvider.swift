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
    func fetchEventsForCalendar(completion: (Result<[Event], APIDataError>) -> Void)
    func fetchCalendar(completion: (Result<Calendar, APIDataError>) -> Void)
}

private enum CalendarAPIAction: String {
    case GetDetails = ""
    case GetEvents  = "events"

    static private let baseURL = NSURL(string: "https://www.googleapis.com/calendar/v3/calendars/")!

    func URLForCalendar(calendarID: String) -> NSURL? {
        return self.dynamicType.baseURL.URLByAppendingPathComponent("\(calendarID)/\(self.rawValue)")
    }
}

final class GoogleCalendarDataProvider: CalendarDataProviding {

    private let dataProvider: APIDataProviding
    let calendarID: String

    init(calendarID: String, dataProvider: APIDataProviding) {
        self.calendarID = calendarID
        self.dataProvider = dataProvider
    }

    private static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return formatter
    }()


    func fetchEventsForCalendar(completion: (Result<[Event], APIDataError>) -> Void) {
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

        dataProvider.request(.GET, url: url, parameters: parameters, encoding: .URL) { result in
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

    func fetchCalendar(completion: (Result<Calendar, APIDataError>) -> Void) {
        guard let url = CalendarAPIAction.GetDetails.URLForCalendar(calendarID) else {
            completion(.Failure(.IncorrectRequestParameters))
            return
        }

        dataProvider.request(.GET, url: url, parameters: nil, encoding: .URL) { result in
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
