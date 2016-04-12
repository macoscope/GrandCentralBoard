//
//  HarvestWidgetView.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-11.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit


class HarvestWidgetView : UIView {
    class func fromNib() -> HarvestWidgetView {
        return NSBundle.mainBundle().loadNibNamed("HarvestWidgetView", owner: nil, options: nil)[0] as! HarvestWidgetView
    }
}
