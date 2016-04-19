//
//  Created by Oktawian Chojnacki on 14.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit


final class AreaBarDashedLineWithLabel: UIView {

    @IBOutlet private var valueLabelRight: UILabel!
    @IBOutlet private var valueLabelLeft: UILabel!
    private var color: UIColor?

    func configureWithViewModel(viewModel: AreaBarItemViewModel) {

        color = viewModel.color
        setNeedsDisplay()

        switch viewModel.valueLabelMode {
        case .Hidden:
            hidden = true
        case .VisibleWithHiddenLabel:
            hidden = false
            valueLabelLeft.hidden = true
            valueLabelRight.hidden = true
        case .VisibleLabelLeft(let text):
            hidden = false
            valueLabelLeft.textColor = color
            valueLabelLeft.hidden = false
            valueLabelLeft.text = text
            valueLabelRight.hidden = true
        case .VisibleLabelRight(let text):
            hidden = false
            valueLabelRight.textColor = color
            valueLabelRight.hidden = false
            valueLabelRight.text = text
            valueLabelLeft.hidden = true
        }
    }

    // MARK: - fromNib

    class func fromNib() -> AreaBarDashedLineWithLabel {
        return NSBundle.mainBundle().loadNibNamed("AreaBarDashedLineWithLabel", owner: nil, options: nil)[0] as! AreaBarDashedLineWithLabel
    }

    // MARK: - Dashed line like it's 1992!

    override func drawRect(rect: CGRect) {

        guard let lineColor = color?.CGColor else { return }

        CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), lineColor)
        let path = UIBezierPath()
        let height = rect.size.height - 1
        path.moveToPoint(CGPoint(x: 0, y: height))
        path.addLineToPoint(CGPoint(x: rect.size.width, y: height))
        path.lineWidth = 1

        let dashes: [CGFloat] = [4, 4]
        path.setLineDash(dashes, count: dashes.count, phase: 0)
        path.lineCapStyle = CGLineCap.Square

        path.stroke()
    }
}
