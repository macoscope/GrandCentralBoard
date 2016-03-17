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
            guard let image = person.bubbleImage.image else { return }
            bubbles.append(BubbleViewModel(name: person.name, image: image, bonus: person.bonus))
        })
        self.bubbles = bubbles
    }
}

struct BubbleViewModel {
    let name: String
    let image: UIImage
    let bonus: Int
}
