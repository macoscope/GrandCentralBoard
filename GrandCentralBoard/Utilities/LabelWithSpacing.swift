//
//  Created by Oktawian Chojnacki on 08.09.2015.
//  Copyright (c) 2015 Macoscope. All rights reserved.
//

import UIKit


class LabelWithSpacing: UILabel {

    @IBInspectable var kerning: Float = 1.0
    @IBInspectable var lineSpace: CGFloat = 0.0

    override func awakeFromNib() {
        super.awakeFromNib()
        applyCustomAttributes()
    }

    func applyCustomAttributes() {
        if let text = text {
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.beginEditing()
            if lineSpace > 0.0 {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = lineSpace
                attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range: NSMakeRange(0, text.characters.count))
            }

            attributedString.addAttribute(NSKernAttributeName, value: kerning, range: NSMakeRange(0, text.characters.count))
            attributedString.endEditing()
            attributedText = attributedString

            sizeToFit()
        }
    }
}