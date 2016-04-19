//
//  Created by Krzysztof Werys on 08/03/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import UIKit

extension CGRect {
    init(size: CGSize, center: CGPoint) {
        var rect = CGRect.zero
        rect.size = size
        rect.center = center
        self = rect
    }

    var center: CGPoint {
        get { return CGPoint(x: self.midX, y: self.midY) }
        set {
            let x = newValue.x - self.width / 2
            let y = newValue.y - self.height / 2
            self.origin = CGPoint(x: x, y: y)
        }
    }
}
