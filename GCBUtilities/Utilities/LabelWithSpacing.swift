//
//  Created by Oktawian Chojnacki on 08.09.2015.
//  Copyright (c) 2015 Macoscope. All rights reserved.
//

import UIKit


public class LabelWithSpacing: UILabel {

    @IBInspectable public var kerning: Float = 1.0 {
        didSet { applyCustomAttributes() }
    }
    @IBInspectable public var lineSpace: CGFloat = 0.0 {
        didSet { applyCustomAttributes() }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        applyCustomAttributes()
    }

    public func applyCustomAttributes() {
        guard let text = text else {
            attributedText = nil
            return
        }

        let attributedString = NSMutableAttributedString(string: text)
        attributedString.beginEditing()
        if lineSpace > 0.0 {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpace
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle,
                                          range: NSRange(location: 0, length: text.characters.count))
        }

        attributedString.addAttribute(NSKernAttributeName, value: kerning,
                                      range: NSRange(location: 0, length: text.characters.count))
        attributedString.endEditing()
        attributedText = attributedString

        sizeToFit()
    }
}
