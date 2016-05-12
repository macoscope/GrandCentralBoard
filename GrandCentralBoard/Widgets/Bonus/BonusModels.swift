//
//  Created by Krzysztof Werys on 24/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import Foundation
import Decodable
import GCBCore

struct BubbleImage {
    let fallbackImageName: String
    let url: String?

    var remoteImage: UIImage?
    var fallbackImage: UIImage? {
        return UIImage(named: fallbackImageName)
    }
    var image: UIImage? {
        return remoteImage ?? fallbackImage
    }

    init(fallbackImageName: String = "placeholder", url: String? = nil, image: UIImage? = nil) {
        self.fallbackImageName = fallbackImageName
        self.url = url
        self.remoteImage = image
    }
}

struct Bonus {
    let name: String
    let amount: Int
    let receiver: Person
    let date: NSDate
    let childBonuses: [Bonus]
}

extension Bonus: Decodable {

    static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()

    static func decode(json: AnyObject) throws -> Bonus {

        let email: String = try json => "receiver" => "email"
        return try Bonus(name: email.removeDomainFromEmail(),
                         amount: json => "amount",
                         receiver: json => "receiver",
                         date: dateFormatter.dateFromString(json => "created_at") ?? NSDate(),
                         childBonuses: json =>? "child_bonuses" ?? [])
    }

    static func decodeBonuses(json: AnyObject) throws -> [Bonus] {
        return try json => "result" as [Bonus]
    }

    static func updatesFromData(data: NSData) throws -> [Bonus] {
        if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
            return try Bonus.decodeBonuses(jsonResult)
        }

        throw DecodeError.WrongFormat
    }

}

struct Person: Hashable, Equatable {
    let id: String
    let name: String
    let email: String
    let lastBonusDate: NSDate?
    let image: UIImage?
    let avatarPath: String?

    var hashValue: Int {
        get {
            return id.hashValue
        }
    }

    func copyWithImage(image: UIImage?) -> Person {
        return Person(id: id, name: name, email: email, lastBonusDate: lastBonusDate, image: image, avatarPath: avatarPath)
    }

    func copyWithLastBonusDate(lastBonusDate: NSDate) -> Person {
        return Person(id: id, name: name, email: email, lastBonusDate: lastBonusDate, image: image, avatarPath: avatarPath)
    }

}

func==(lhs: Person, rhs: Person) -> Bool {
    return lhs.id == rhs.id
}

extension Person: Decodable {

    static func decode(json: AnyObject) throws -> Person {
        return try Person(id: json => "id",
                          name: json => "display_name",
                          email: json => "email",
                          lastBonusDate: nil,
                          image: nil,
                          avatarPath: json =>? "full_pic_url" ?? json =>? "profile_pic_url")
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

enum DecodeError: ErrorType, HavingMessage {
    case WrongFormat

    var message: String {
        switch self {
            case .WrongFormat:
                return NSLocalizedString("Wrong format.", comment: "")
        }
    }
}
