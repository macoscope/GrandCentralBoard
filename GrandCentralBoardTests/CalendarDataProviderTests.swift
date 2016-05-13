//
//  CalendarAPIProviderTests.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 11.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import XCTest
import Decodable
@testable import GrandCentralBoard
import GCBCore


private let calendarDictionary = ["kind": "calendar#calendar", "summary": "TestCalendar"]
private let eventsDictionary = ["kind": "calendar#events", "items" :
    [
        ["kind": "calendar#event", "summary" : "Name of event #1", "start" : ["dateTime" : "2016-04-11T08:00:00Z"]],
        ["kind": "calendar#event", "start" : ["dateTime" : "2016-04-11T12:15:00Z"]]
    ]
]

class TestAPIDataProvider: APIDataProviding {

    func request(method: GrandCentralBoard.Method, url: NSURL, parameters: [String : AnyObject]?, encoding: ParameterEncoding,
                 completion: Result<AnyObject> -> Void) {
        let urlString = url.URLString
        if urlString.hasSuffix("/events") {
            completion(.Success(eventsDictionary))
        } else {
            completion(.Success(calendarDictionary))
        }
    }
}

class CalendarDataProviderTests: XCTestCase {

    let calendarDataProvider = GoogleCalendarDataProvider(calendarID: "id", dataProvider: TestAPIDataProvider())
    private static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return formatter
    }()

    func testCalendarDataDeserialization() {

        calendarDataProvider.fetchCalendar { (result) in
            switch result {
            case .Success(let calendar):
                XCTAssertEqual(calendarDictionary["summary"], calendar.name)
            case .Failure(let error):
                XCTFail("\(error)")
            }
        }
    }

    func testCalendarEventsDeserialization() {

        calendarDataProvider.fetchEventsForCalendar { (result) in
            switch result {
            case .Success(let events):
                let eventItems = eventsDictionary["items"] as! [NSDictionary]
                XCTAssertEqual(eventItems.count, events.count)
                for i in 0..<events.count {
                    let eventName: String = eventItems[i]["summary"] as? String ?? "-"
                    let eventDateString: String = try! eventItems[i] => "start" => "dateTime"
                    let eventDate = CalendarDataProviderTests.dateFormatter.dateFromString(eventDateString)!
                    XCTAssertEqual(eventName, events[i].name)
                    XCTAssertEqual(eventDate, events[i].time)
                }
            case .Failure(let error):
                XCTFail("\(error)")
            }
        }
    }
}
