//
//  Created by Oktawian Chojnacki on 25.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Operations
import GrandCentralBoardCore
import Alamofire
import Decodable

struct EventsSourceSettings : Decodable {
    let calendarID: String
    let clientID: String
    let clientSecret: String
    let refreshToken: String


    static func decode(jsonObject: AnyObject) throws -> EventsSourceSettings {
        return try EventsSourceSettings(calendarID: jsonObject => "calendarID",
                                        clientID: jsonObject => "clientID",
                                        clientSecret: jsonObject => "clientSecret",
                                        refreshToken: jsonObject => "refreshToken")
    }
}

final class EventsSource : Asynchronous {

    typealias ResultType = GrandCentralBoardCore.Result<[Event]>

    let interval: NSTimeInterval = 60
    let sourceType: SourceType = .Momentary

    private let dataProvider: CalendarDataProviding
    private let calendarID: String

    private var calendarName: String?

    private let operationQueue = OperationQueue()

    init(settings: EventsSourceSettings, dataDownloader: DataDownloading) {
        let networkRequestManager = Manager()
        let tokenProvider = GoogleTokenProvider(clientID: settings.clientID, clientSecret: settings.clientSecret, refreshToken: settings.refreshToken)
        let apiDataProvider = GoogleAPIDataProvider(tokenProvider: tokenProvider, networkRequestManager: networkRequestManager)
        self.dataProvider = GoogleCalendarDataProvider(dataProvider: apiDataProvider)
        self.calendarID = settings.calendarID
    }

    private func fetchCalendarNameOperation() -> NSOperation {
        let dataProvider = self.dataProvider
        let calendarID = self.calendarID
        return  BlockOperation(block: { [weak self] continueWithError in
            dataProvider.fetchCalendar(calendarID, completion: { (result) in
                switch result {
                case .Success(let calendarModel): self?.calendarName = calendarModel.name
                case .Failure: break
                }
                continueWithError(error: nil)
            })
        })
    }

    private func fetchEventsDataOperation(closure: (ResultType) -> Void) -> NSOperation {
        let dataProvider = self.dataProvider
        let calendarID = self.calendarID
        return  BlockOperation(block: { continueWithError in
            dataProvider.fetchEventsForCalendar(calendarID, completion: { (result) in
                switch result {
                case .Success(let events): closure(.Success(events))
                case .Failure(let error): closure(.Failure(error))
                }
                continueWithError(error: nil)
            })
        })
    }


    func read(closure: (ResultType) -> Void) {
        operationQueue.addOperation(fetchEventsDataOperation(closure))
    }
}
