//
//  Created by Oktawian Chojnacki on 02.01.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

final class Slot : UIView {

    @IBOutlet var button: UIButton!

    var widgetView: UIView?

    class func fromNib() -> Slot {
        return NSBundle.mainBundle().loadNibNamed("Slot", owner: nil, options: nil)[0] as! Slot
    }

    func setWidget(widget: UIView) {
        widgetView = widget

        fillViewWithView(widget, animated: true)
    }

    @IBAction func addWidget() {
        self.setWidget(ImageWidget.fromNib())
        button.enabled = false

        button.superview?.setNeedsFocusUpdate()
    }
}