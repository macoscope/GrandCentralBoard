//
//  Created by Oktawian Chojnacki on 02.01.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit


public extension UIView {

    /**
     Fill view with another view using AutoLayout.

     - parameter view:     view to be filled with.
     - parameter animated: should animate the transition.
     */
    func fillViewWithView(view: UIView, animated: Bool) {

        view.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(view)

        view.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        view.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        view.leftAnchor.constraintEqualToAnchor(leftAnchor).active = true
        view.rightAnchor.constraintEqualToAnchor(rightAnchor).active = true

        if animated {
            UIView.animateWithDuration(0.2) {
                self.layoutIfNeeded()
            }
        }
    }
}
