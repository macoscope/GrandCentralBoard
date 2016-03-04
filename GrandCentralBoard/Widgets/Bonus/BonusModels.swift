//
//  Created by Krzysztof Werys on 24/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import Foundation
import Decodable

struct BubbleImage {
    let imageName: String
}

extension BubbleImage : Decodable {
    static func decode(j: AnyObject) throws -> BubbleImage{
        return try BubbleImage(imageName: j => "imageName")
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
    let image: BubbleImage
    let bonus: Bonus
    
    func copyPersonWithTotalBonus(totalBonus: Int) -> Person {
        return Person(name: name, image: image, bonus: Bonus(total: totalBonus))
    }
}

extension Person : Decodable {
    static func decode(j: AnyObject) throws -> Person {
        return try Person(name: j => "name",
                         image: j => "image",
                         bonus: j => "bonus")
    }
}
