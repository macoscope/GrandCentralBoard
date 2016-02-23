//
//  Created by Oktawian Chojnacki on 12.01.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

class FocusableView : UIView {

    override func canBecomeFocused() -> Bool {
        return true
    }

    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        if context.previouslyFocusedView === self {
            coordinator.addCoordinatedAnimations({
                context.previouslyFocusedView?.transform = CGAffineTransformMakeScale(1.0, 1.0)
                }, completion: nil)
        }

        if context.nextFocusedView === self {
            coordinator.addCoordinatedAnimations({
                context.nextFocusedView?.transform = CGAffineTransformMakeScale(1.1, 1.1)
                }, completion: nil)
        }
    }
}