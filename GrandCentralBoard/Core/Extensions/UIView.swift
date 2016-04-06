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

/// () -> Void cannot be stored as associatedObject, we need a wrapper.
private final class BlockWrapper {
    let block: () -> Void
    
    init(block: () -> Void) {
        self.block = block
    }
}

public extension UIView {
    private struct AssociatedKey {
        static var onDidBecomeActiveKey = "onDidBecomeActiveKey"
    }
    
    private var onApplicationDidBecomeActive: (() -> Void)? {
        get {
            let wrapper = objc_getAssociatedObject(self, &AssociatedKey.onDidBecomeActiveKey) as? BlockWrapper
            return wrapper?.block
        }
        set {
            let notificationCenter = NSNotificationCenter.defaultCenter()
            let notificationName = UIApplicationDidBecomeActiveNotification
            let selector = #selector(applicationDidBecomeActiveNotification)
            
            if newValue == nil {
                notificationCenter.removeObserver(self, name: notificationName, object: nil)
            }
            else if self.onApplicationDidBecomeActive == nil {
                notificationCenter.addObserver(self, selector: selector, name: notificationName, object: nil)
            }
            
            return objc_setAssociatedObject(self,
                                            &AssociatedKey.onDidBecomeActiveKey,
                                            newValue.map(BlockWrapper.init),
                                            .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc private func applicationDidBecomeActiveNotification() {
        self.onApplicationDidBecomeActive?()
    }
    
    func startFlashingWithInterval(interval: NSTimeInterval, alphaDepth: CGFloat) {
        
        self.onApplicationDidBecomeActive = { [weak self] in
            self?.stopFlashing()
            self?.startFlashingWithInterval(interval, alphaDepth: alphaDepth)
        }
        
        UIView.animateWithDuration(interval,
                                   delay: 0.0,
                                   options: [.CurveEaseInOut, .Autoreverse, .Repeat],
                                   animations: { self.alpha = alphaDepth },
                                   completion: nil)
    }
    
    func stopFlashing() {
        self.onApplicationDidBecomeActive = nil
        layer.removeAllAnimations()
        alpha = 1
    }
}
