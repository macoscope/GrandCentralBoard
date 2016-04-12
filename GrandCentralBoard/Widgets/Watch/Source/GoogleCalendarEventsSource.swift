//
//  Created by Oktawian Chojnacki on 25.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Operations
import GrandCentralBoardCore
import Decodable

struct GoogleCalendarEventsSourceSettings : Decodable {
    let calendarID: String
    let clientID: String
    let clientSecret: String
    let refreshToken: String


    static func decode(jsonObject: AnyObject) throws -> GoogleCalendarEventsSourceSettings {
        return try GoogleCalendarEventsSourceSettings(calendarID: jsonObject => "calendarID",
                                        clientID: jsonObject => "clientID",
                                        clientSecret: jsonObject => "clientSecret",
                                        refreshToken: jsonObject => "refreshToken")
    }
}

final class GoogleCalendarEventsSource : EventsSource {

    private let dataProvider: CalendarDataProviding
    private let calendarID: String

    private var calendarName: String?

    init(settings: GoogleCalendarEventsSourceSettings, networkRequestManager: NetworkRequestManager) {
        let tokenProvider = GoogleTokenProvider(clientID: settings.clientID, clientSecret: settings.clientSecret, refreshToken: settings.refreshToken)
        let apiDataProvider = GoogleAPIDataProvider(tokenProvider: tokenProvider, networkRequestManager: networkRequestManager)
        self.dataProvider = GoogleCalendarDataProvider(dataProvider: apiDataProvider)
        self.calendarID = settings.calendarID
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
