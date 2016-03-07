//
//  Created by Krzysztof Werys on 24/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import Foundation
import Decodable

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

extension BubbleImage : Decodable {
    static func decode(j: AnyObject) throws -> BubbleImage{
        return try BubbleImage(imageName: j => "imageName",
                                     url: j => "url")
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

extension Bonus : Decodable {
    static func decode(j: AnyObject) throws -> Bonus {
        return try Bonus(total: j => "total", last: j => "last")
    }
}

struct Person {
    let name: String
    let bubbleImage: BubbleImage
    let bonus: Bonus
    
    func copyPersonWithTotalBonus(totalBonus: Int) -> Person {
        return Person(name: name, bubbleImage: bubbleImage, bonus: Bonus(total: totalBonus))
    }
    
    func copyPersonWithImage(image: BubbleImage) -> Person {
        return Person(name: name, bubbleImage: image, bonus: bonus)
    }
}

extension Person : Decodable {
    static func decode(j: AnyObject) throws -> Person {
        return try Person(name: j => "name",
                   bubbleImage: j => "bubbleImage",
                         bonus: j => "bonus")
    }
}
