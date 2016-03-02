//
//  Created by Oktawian Chojnacki on 25.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//


import Foundation
import Alamofire
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

    var message: String {
        switch self {
            case .CannotConvertDate:
                return NSLocalizedString("Unable to convert string to date.", comment: "")
        }
    }
}

extension Events : Decodable {

    static func decode(json: AnyObject) throws -> Events {
        return try Events(time: NSDate(), events:
            (json => "events" as! [AnyObject]).flatMap({ try Event(time: stringToDate($0 => "time"), name: $0 => "name") })
        )
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

    private let path: String

    init(settings: EventsSourceSettings) {
        self.path = settings.calendarPath
    }

    func read(closure: (ResultType) -> Void) {
        Alamofire.request(.GET, path).response { (request, response, data, error) in
            do {
                if let data = data, jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {

                    let events = try Events.decode(jsonResult)
                    closure(.Success(events))

                    return
                }

                closure(.Failure(EventsSourceError.DownloadFailed))

            } catch let error {
                closure(.Failure(error))
                return
            }
        }
    }
}