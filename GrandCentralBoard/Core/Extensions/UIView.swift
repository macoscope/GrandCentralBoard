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
