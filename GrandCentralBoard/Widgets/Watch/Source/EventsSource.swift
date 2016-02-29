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

extension Events : Decodable {
    static func decode(json: AnyObject) throws -> Events {
        return try Events(time: NSDate(), events:
            (json => "events" as! [AnyObject]).flatMap({ try? Event(time: stringToDate($0 => "time"), name: $0 => "name") })
        )
    }

    static let dateFormatter = NSDateFormatter()

    static func stringToDate(string: String) -> NSDate {
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return dateFormatter.dateFromString(string)! //NSDate(timeIntervalSinceNow: 15*60)//
    }
}

struct EventsSourceSettings {
    let calendarPath: String
}

final class EventsSource : Asynchronous {

    typealias ResultType = Result<Events>

    let optimalInterval: NSTimeInterval = 60
    let sourceType: SourceType = .Momentary

    private let path: String

    init(settings: EventsSourceSettings) {
        self.path = settings.calendarPath
    }

    func read(closure: (ResultType) -> Void) {
        Alamofire.request(.GET, path).response { (request, response, data, error) in
            if let data = data, jsonResult = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                if let jsonResult = jsonResult, events = try? Events.decode(jsonResult) {
                    closure(.Success(events))
                    return
                }

                closure(.Failure)
            }
        }
       //
    }
}