//
//  Created by Oktawian Chojnacki on 25.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
import Decodable
import GrandCentralBoardCore

enum EventsError : ErrorType, HavingMessage {
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

struct EventsSourceSettings : Decodable {
    let calendarPath: String

    static func decode(json: AnyObject) throws -> EventsSourceSettings {
        return try EventsSourceSettings(calendarPath: json => "calendar")
    }
}

enum EventsSourceError : ErrorType, HavingMessage {
    case DownloadFailed

    var message: String {
        switch self {
            case .DownloadFailed:
                return NSLocalizedString("Cannot download data!", comment: "")
        }
    }
}

final class RemoteEventsSource : EventsSource {

    private let dataDownloader: DataDownloading

    private let path: String

    init(settings: EventsSourceSettings, dataDownloader: DataDownloading) {
        self.path = settings.calendarPath
        self.dataDownloader = dataDownloader
    }

    override func read(closure: (ResultType) -> Void) {

        dataDownloader.downloadDataAtPath(path) { result in
            switch result {
                case .Success(let data):
                    do {
                        try closure(.Success(Event.decodeArrayFromData(data)))
                    } catch (let error) {
                        closure(.Failure(error))
                    }
                case .Failure(let error):
                    closure(.Failure(error))
            }
        }
    }
}
