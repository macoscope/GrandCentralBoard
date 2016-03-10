//
//  Created by Oktawian Chojnacki on 25.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//


import Foundation
import Decodable

struct Event : Timed {
    let time: NSDate
    let name: String
}

struct Events : Timed {
    let time: NSDate
    let events: [Event]
}

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

extension Events : Decodable {

    static func decode(jsonObject: AnyObject) throws -> Events {
        if let rawEvents = try (jsonObject => "events") as? [AnyObject] {
            let events = try rawEvents.map({ try Event(time: stringToDate($0 => "time"), name: $0 => "name") })
            return Events(time: NSDate(), events: events)
        }

        throw EventsError.WrongFormat
    }

    static let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return dateFormatter
    }()

    static func stringToDate(string: String) throws -> NSDate {
        let dateFromFormatter = dateFormatter.dateFromString(string)

        guard let date = dateFromFormatter else { throw EventsError.CannotConvertDate }

        return date
    }
}

extension Events {

    static func eventsFromData(data: NSData) throws -> Events {
        
        if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
            return try Events.decode(jsonResult)
        }

        throw EventsError.WrongFormat
    }
}

struct EventsSourceSettings {
    let calendarPath: String
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

final class EventsSource : Asynchronous {

    typealias ResultType = Result<Events>

    let interval: NSTimeInterval = 60
    let sourceType: SourceType = .Momentary
    private let dataDownloader: DataDownloading

    private let path: String

    init(settings: EventsSourceSettings, dataDownloader: DataDownloading) {
        self.path = settings.calendarPath
        self.dataDownloader = dataDownloader
    }

    func read(closure: (ResultType) -> Void) {

        dataDownloader.downloadDataAtPath(path) { result in
            switch result {
                case .Success(let data):
                    do {
                        try closure(.Success(Events.eventsFromData(data)))
                    } catch (let error) {
                        closure(.Failure(error))
                    }
                case .Failure(let error):
                    closure(.Failure(error))
            }
        }
    }
}