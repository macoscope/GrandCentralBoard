//
//  SlackWidgetView.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 27.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import UIKit


final class SlackWidgetView: UIView {

    @IBOutlet private weak var messageView: MessageBubbleView!
    @IBOutlet private weak var avatarView: SlackAvatarView!

    func configureWithViewModel(viewModel: SlackWidgetViewModel) {
        messageView.text = viewModel.message
        avatarView.image = viewModel.avatarImage
    }

    class func fromNib() -> SlackWidgetView {
        return NSBundle.mainBundle().loadNibNamed("SlackWidgetView", owner: nil, options: nil)[0] as! SlackWidgetView
    }
}
