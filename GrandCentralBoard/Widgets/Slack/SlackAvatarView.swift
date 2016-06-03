//
//  SlackAvatarView.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 27.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import UIKit
import GCBCore


final class SlackAvatarView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    private func setUp() {
        super.layoutSubviews()

        layer.cornerRadius = min(bounds.width / 2, bounds.height / 2)
        layer.masksToBounds = true
        layer.borderWidth = 2
        layer.borderColor = UIColor.gcb_greenColor().CGColor
    }
}
