//
//  Created by Krzysztof Werys on 24/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import Foundation
import Decodable
import GrandCentralBoardCore

struct BubbleImage {
    let localImageName: String?
    let url: String?
    
    var remoteImage: UIImage?
    var localImage: UIImage? {
        guard let name = localImageName else { return nil }
        return UIImage(named: name)
    }
    
    init(imageName: String? = nil, url: String? = nil, image: UIImage? = nil) {
        self.localImageName = imageName
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
        return Person(name: update.name, bubbleImage: BubbleImage(url: imageUrl), bonus: update.bonus, lastUpdate: update.date)
    }
    
    func copyByUpdating(update: Update, imageUrl: String? = nil) -> Person {
        return Person(name: name, bubbleImage: BubbleImage(url: imageUrl), bonus: bonus + update.bonus, lastUpdate: update.date)
    }

    func copyPersonWithImage(image: BubbleImage) -> Person {
        return Person(name: name, bubbleImage: image, bonus: bonus, lastUpdate: lastUpdate)
    }
}

struct Updates {
    let all: [Update]
}

extension Updates: Decodable {
    static func decode(j: AnyObject) throws -> Updates {
        return try Updates(all: j => "result" as [Update])
    }
    
    static func updatesFromData(data: NSData) throws -> Updates {
        
        if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
            return try Updates.decode(jsonResult)
        }

        throw DecodeError.WrongFormat
    }
}

struct Update {
    let name: String
    let bonus: Int
    let date: NSDate
}

extension Update: Decodable {
    static func decode(j: AnyObject) throws -> Update {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return try Update(name: removeDomainFromEmail(j => "receiver" => "email"),
            bonus: j => "amount",
            date: formatter.dateFromString(j => "created_at") ?? NSDate())
    }
    
    static func removeDomainFromEmail(email: String) -> String {
        guard let index = email.rangeOfString("@", options: .BackwardsSearch)?.startIndex else {
            return email
        }
        return email.substringToIndex(index)
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
