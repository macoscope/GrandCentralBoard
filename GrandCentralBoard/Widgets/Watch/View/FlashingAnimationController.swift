//
//  Created by Oktawian Chojnacki on 06.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit


final class FlashingAnimationController {

    private weak var view: UIView?
    private let interval: NSTimeInterval
    private let alphaDepth: CGFloat
    private let animationKey = "layerAnimation"

    required init(view: UIView, interval: NSTimeInterval, alphaDepth: CGFloat) {
        self.view = view
        self.interval = interval
        self.alphaDepth = alphaDepth
    }

    func startFlashing() {
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = interval
        pulseAnimation.fromValue = 1
        pulseAnimation.toValue = alphaDepth
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = FLT_MAX
        pulseAnimation.removedOnCompletion = false
        view?.layer.addAnimation(pulseAnimation, forKey: animationKey)
    }

    func stopFlashing() {
        view?.layer.removeAnimationForKey(animationKey)
        view?.alpha = 1
    }
}
