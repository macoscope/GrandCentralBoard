//
//  MessageBubbleView.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 25.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import UIKit


@IBDesignable
final class MessageBubbleView: UIView {

    private lazy var imageView: UIImageView = { [unowned self] in
        let imageView = UIImageView(image: UIImage(named: "message_bubble")!)
        self.addSubview(imageView)
        return imageView
    }()

    private lazy var label: UILabel = { [unowned self] in
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(40)
        label.textColor = UIColor.whiteColor()
        label.numberOfLines = 0

        self.addSubview(label)
        return label
    }()

    @IBInspectable var text: String = "" {
        didSet {
            label.text = text
            setNeedsLayout()
        }
    }

    override func layoutSubviews() {
        let textToBubbleMargin = (x: CGFloat(33), y: CGFloat(25.0))
        let maxTextWidth = bounds.width - 2 * textToBubbleMargin.x
        let maxTextHeight = bounds.height - 2 * textToBubbleMargin.y

        let labelText: NSString = label.text ?? ""
        let textSize = labelText.boundingRectWithSize(CGSize(width: maxTextWidth, height: maxTextHeight),
                                                      options: .UsesLineFragmentOrigin,
                                                      attributes: [NSFontAttributeName: label.font],
                                                      context: nil)
        let textHeight = min(textSize.height, maxTextHeight)

        let imageHeight = textHeight + 2 * textToBubbleMargin.y
        imageView.frame = CGRect(x: 0, y: bounds.height - imageHeight, width: bounds.width, height: imageHeight)

        label.frame = CGRect(x: textToBubbleMargin.x, y: imageView.frame.minY + textToBubbleMargin.y, width: maxTextWidth, height: textHeight)
    }
}
