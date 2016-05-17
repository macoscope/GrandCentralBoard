//
//  Created by Krzysztof Werys on 16.05.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

public class WidgetTemplateView: UIView {

    @IBOutlet private var headerView: UIView!
    @IBOutlet private var contentView: UIView!

    public class func fromNib() -> WidgetTemplateView {
        return NSBundle(forClass: WidgetTemplateView.self).loadNibNamed("WidgetTemplateView", owner: nil, options: nil)[0] as! WidgetTemplateView
    }
}