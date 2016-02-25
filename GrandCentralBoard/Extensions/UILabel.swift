//
//  Created by Oktawian Chojnacki on 23.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

extension UILabel {
    func setTextIfNotTheSame(text: String?) {
        guard self.text != text else { return }

        UIView.animateWithDuration(0.3, animations: { self.alpha = 0 }, completion: { completed in
            if completed {
                self.text = text
                UIView.animateWithDuration(0.3, animations: { self.alpha = 1 })
            }
        })
    }
}