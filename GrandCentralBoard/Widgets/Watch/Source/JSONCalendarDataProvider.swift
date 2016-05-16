//
//  Created by Oktawian Chojnacki on 25.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
import GCBCore
import GCBUtilities

enum EventsError: ErrorType, HavingMessage {
    case CannotConvertDate
    case WrongFormat

    var message: String {
        switch self {
        case .CannotConvertDate:
            return NSLocalizedString("Unable to convert string to date.", comment: "")
        case .WrongFormat:
            return NSLocalizedString("Wrong format.", comment: "")
        }
    }
}

final class JSONCalendarDataProvider: CalendarDataProviding {

    private let dataDownloader: DataDownloading
    private let path: String

    init(path: String, dataDownloader: DataDownloading) {
        self.path = path
        self.dataDownloader = dataDownloader
    }

    func fetchEventsForCalendar(completion: (Result<[Event]>) -> Void) {
        dataDownloader.downloadDataAtPath(path) { result in
            switch result {
            case .Success(let data):
                do {
                    try completion(.Success(Event.decodeArrayFromData(data)))
                } catch (let error) {
                    completion(.Failure(APIDataError.ModelDecodeError(error)))
                }
            case .Failure(let error):
                completion(.Failure(APIDataError.UnderlyingError(error as NSError)))
            }
        }
    }

    func fetchCalendar(completion: (Result<Calendar>) -> Void) {
        dataDownloader.downloadDataAtPath(path) { result in
            switch result {
            case .Success(let data):
                do {
                    try completion(.Success(Calendar.decodeFromData(data)))
                } catch (let error) {
                    completion(.Failure(APIDataError.ModelDecodeError(error)))
                }
            case .Failure(let error):
                completion(.Failure(APIDataError.UnderlyingError(error as NSError)))
            }
        }
    }
}
