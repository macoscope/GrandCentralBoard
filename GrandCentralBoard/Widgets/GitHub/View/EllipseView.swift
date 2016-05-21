//
//  EllipseView.swift
//  GrandCentralBoard
//
//  Created by mlaskowski on 21/05/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit


@IBDesignable
final class EllipseView: UIView {

    @IBInspectable var color: UIColor = .blackColor() {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var strokeWidth: CGFloat = 1 {
        didSet { setNeedsDisplay() }
    }

    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, color.CGColor)
        CGContextSetLineWidth(context, strokeWidth)

        let margin = strokeWidth / 2
        let strokedRect = CGRect(x: margin, y: margin, width: rect.width - margin * 2, height: rect.height - margin * 2)
        CGContextStrokeEllipseInRect(context, strokedRect)
    }
}
