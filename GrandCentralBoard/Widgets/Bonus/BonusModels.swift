//
//  Created by Krzysztof Werys on 24/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import Foundation

struct BubbleImage {
    let imageName: String
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
    let image: BubbleImage
    let bonus: Bonus
    
    func copyPersonWithTotalBonus(totalBonus: Int) -> Person {
        return Person(name: name, image: image, bonus: Bonus(total: totalBonus))
    }
}
