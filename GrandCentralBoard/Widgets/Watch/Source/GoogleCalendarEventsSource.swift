//
//  Created by Oktawian Chojnacki on 25.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Operations
import GrandCentralBoardCore
import Decodable

struct GoogleCalendarSourceSettings : Decodable {
    let calendarID: String
    let clientID: String
    let clientSecret: String
    let refreshToken: String


    static func decode(jsonObject: AnyObject) throws -> GoogleCalendarSourceSettings {
        return try GoogleCalendarSourceSettings(calendarID: jsonObject => "calendarID",
                                        clientID: jsonObject => "clientID",
                                        clientSecret: jsonObject => "clientSecret",
                                        refreshToken: jsonObject => "refreshToken")
    }
}

final class GoogleCalendarEventsSource : EventsSource {

    private let dataProvider: CalendarDataProviding
    private let calendarID: String

    private var calendarName: String?

    init(calendarID: String, dataProvider: CalendarDataProviding) {
        self.dataProvider = dataProvider
        self.calendarID = calendarID
    }

    override func read(closure: (ResultType) -> Void) {
        dataProvider.fetchEventsForCalendar(calendarID, completion: { (result) in
            switch result {
            case .Success(let events): closure(.Success(events))
            case .Failure(let error): closure(.Failure(error))
            }
        })

    }
}
