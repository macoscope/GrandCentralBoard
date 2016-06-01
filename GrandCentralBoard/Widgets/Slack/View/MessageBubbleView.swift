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

    private let textToBubbleMargin = UIEdgeInsets(top: 25, left: 33, bottom: 25, right: 43)

    private lazy var imageView: UIImageView = { [unowned self] in
        let imageView = UIImageView(image: UIImage(named: "message_bubble")!)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)

        return imageView
        }()

    private lazy var label: UILabel = { [unowned self] in
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFontOfSize(40)
        label.textColor = UIColor.whiteColor()
        label.numberOfLines = 0

        self.addSubview(label)
        return label
        }()

    @IBInspectable var text: String = "" {
        didSet {
            label.text = text
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setConstraints()
    }

    private func setConstraints() {
        label.topAnchor.constraintGreaterThanOrEqualToAnchor(topAnchor, constant: textToBubbleMargin.top).active = true
        label.leftAnchor.constraintEqualToAnchor(leftAnchor, constant: textToBubbleMargin.left).active = true
        label.rightAnchor.constraintEqualToAnchor(rightAnchor, constant: -textToBubbleMargin.right).active = true
        label.bottomAnchor.constraintEqualToAnchor(bottomAnchor, constant: -textToBubbleMargin.bottom).active = true

        imageView.topAnchor.constraintEqualToAnchor(label.topAnchor, constant: -textToBubbleMargin.top).active = true
        imageView.leftAnchor.constraintEqualToAnchor(leftAnchor, constant: 0).active = true
        imageView.rightAnchor.constraintEqualToAnchor(rightAnchor, constant: 0).active = true
        imageView.bottomAnchor.constraintEqualToAnchor(bottomAnchor, constant: 0).active = true
    }
}
