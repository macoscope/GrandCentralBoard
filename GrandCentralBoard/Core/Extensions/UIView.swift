//
//  Created by Oktawian Chojnacki on 02.01.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit


public extension UIView {

    func fillViewWithView(view: UIView, animated: Bool) {

        view.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(view)

        let viewsDict = ["view" : view]

        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: [], metrics: nil, views: viewsDict)
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: viewsDict)
        self.addConstraints(horizontalConstraints)
        self.addConstraints(verticalConstraints)

        if animated {
            UIView.animateWithDuration(0.2) {
                self.layoutIfNeeded()
            }
        }
    }
}

private var isFlashingKey: UInt8 = 0

private final class BlockWrapper {
    let block: () -> Void
    
    init(block: () -> Void) {
        self.block = block
    }
}

public extension UIView {
    
    private var onApplicationDidBecomeActive: BlockWrapper? {
        get {
            return objc_getAssociatedObject(self, &isFlashingKey) as? BlockWrapper
        }
        set {
            let notificationCenter = NSNotificationCenter.defaultCenter()
            let notificationName = UIApplicationDidBecomeActiveNotification
            
            if newValue == nil {
                notificationCenter.removeObserver(self, name: notificationName, object: nil)
            }
            else {
                let selector = #selector(applicationDidBecomeActiveNotification)
                notificationCenter.addObserver(self, selector: selector, name: notificationName, object: nil)
            }
            
            return objc_setAssociatedObject(self, &isFlashingKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc private func applicationDidBecomeActiveNotification() {
        self.onApplicationDidBecomeActive?.block()
    }
    
    func startFlashingWithInterval(interval: NSTimeInterval, alphaDepth: CGFloat) {
        
        self.onApplicationDidBecomeActive = BlockWrapper { [weak self] in
            self?.stopFlashing()
            self?.startFlashingWithInterval(interval, alphaDepth: alphaDepth)
        }
        
        UIView.animateWithDuration(interval, delay: 0.0, options:
            [
                .CurveEaseInOut,
                .Autoreverse,
                .Repeat
            ],
            animations: {
                self.alpha = alphaDepth
            },
            completion: nil)
    }

    func stopFlashing() {
        self.onApplicationDidBecomeActive = nil
        layer.removeAllAnimations()
        alpha = 1
    }
}
