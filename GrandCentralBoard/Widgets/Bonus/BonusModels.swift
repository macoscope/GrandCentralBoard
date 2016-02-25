//
//  Created by krris on 24/02/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation

struct BubbleImage {
    let imageName: String
}

struct Bonus {
    let total: Int
    let last: Int
}

struct Person {
    let name: String
    let image: BubbleImage
    let bonus: Bonus
}
