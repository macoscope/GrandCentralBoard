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
            bubbles.append(BubbleViewModel(name: person.name, image: person.image ?? UIImage.generatePlaceholerImage()))
        })
        self.bubbles = bubbles
    }
}

struct BubbleViewModel {
    let name: String
    let image: UIImage
}


extension UIImage {

    static func generatePlaceholerImage() -> UIImage {
        let size = CGSizeMake(40, 40)
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.redColor().setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}
