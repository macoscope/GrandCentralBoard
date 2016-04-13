//
//  Created by Krzysztof Werys on 24/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import UIKit

struct BonusWidgetViewModel {
    let bubbles: [BubbleViewModel]
}

extension BonusWidgetViewModel {
    init(people: [Person]) {
        var bubbles: [BubbleViewModel] = []
        people.forEach({ person in
            if let lastBonusDate = person.lastBonusDate {
                bubbles.append(BubbleViewModel(name: person.name, lastBonusDate: lastBonusDate, image: person.image ?? UIImage.generatePlaceholderImage()))
            }
        })
        self.bubbles = bubbles
    }
}

struct BubbleViewModel {
    let name: String
    let lastBonusDate: NSDate
    let image: UIImage
}
