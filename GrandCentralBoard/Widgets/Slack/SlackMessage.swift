//
//  SlackMessage.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 11.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import UIKit

struct SlackMessage {
    let text: String
    let timestamp: NSDate
    var author: String

    var channel: String?
    var avatar: UIImage?
}
