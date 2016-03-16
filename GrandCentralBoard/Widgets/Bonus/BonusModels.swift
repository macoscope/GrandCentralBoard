//
//  Created by Krzysztof Werys on 24/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import Foundation
import Decodable
import GrandCentralBoardCore

struct BubbleImage {
    let fallbackImageName: String
    let url: String?
    
    var remoteImage: UIImage?
    var fallbackImage: UIImage? {
        return UIImage(named: fallbackImageName)
    }
    
    init(fallbackImageName: String = "placeholder", url: String? = nil, image: UIImage? = nil) {
        self.fallbackImageName = fallbackImageName
        self.url = url
        self.remoteImage = image
    }
}

struct Bonus {
    let total: Int
    let last: Int
    
    init(total: Int, last: Int = 0) {
        self.total = total
        self.last = last
    }
}

struct Person {
    let name: String
    let bubbleImage: BubbleImage
    let bonus: Int
    let lastUpdate: NSDate
    
    static func personFromUpdate(update: Update, imageUrl: String? = nil) -> Person {
        return Person(name: update.name, bubbleImage: BubbleImage(url: imageUrl), bonus: update.totalBonus, lastUpdate: update.date)
    }
    
    func copyByUpdating(update: Update, imageUrl: String? = nil) -> Person {
        return Person(name: name, bubbleImage: BubbleImage(url: imageUrl), bonus: bonus + update.totalBonus, lastUpdate: update.date)
    }

    func copyPersonWithImage(image: BubbleImage) -> Person {
        return Person(name: name, bubbleImage: image, bonus: bonus, lastUpdate: lastUpdate)
    }
}

struct Update {
    let name: String
    let bonus: Int
    let date: NSDate
    let childBonuses: [Update]
    
    var totalBonus: Int {
        return bonus + childBonuses.reduce(0, combine: {return $0 + $1.bonus})
    }
}


extension Update: Decodable {
    static let formatter = NSDateFormatter()

    static func decode(j: AnyObject) throws -> Update {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let email: String = try j => "receiver" => "email"
        return try Update(name: email.removeDomainFromEmail(),
            bonus: j => "amount",
            date: formatter.dateFromString(j => "created_at") ?? NSDate(),
            childBonuses: j => "child_bonuses" ?? [])
    }

    static func decodeUpdates(j: AnyObject) throws -> [Update] {
        return try j => "result" as [Update]
    }

    static func updatesFromData(data: NSData) throws -> [Update] {
        if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
            return try Update.decodeUpdates(jsonResult)
        }

        throw DecodeError.WrongFormat
    }
}

extension String {
    func removeDomainFromEmail() -> String {
        guard let index = rangeOfString("@", options: .BackwardsSearch)?.startIndex else {
            return self
        }
        return self.substringToIndex(index)
    }
}

enum DecodeError : ErrorType, HavingMessage {
    case WrongFormat

    var message: String {
        switch self {
            case .WrongFormat:
                return NSLocalizedString("Wrong format.", comment: "")
        }
    }
}
