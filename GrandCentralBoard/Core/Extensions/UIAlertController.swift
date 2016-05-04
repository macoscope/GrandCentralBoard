//
//  Created by Oktawian Chojnacki on 02.03.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit


public extension UIAlertController {
    /**
     Create `UIAlertController` with error message and just one `Retry` button calling closure on tap.

     - parameter message:      error message.
     - parameter retryClosure: this closure will be called when user taps `Retry` button.

     - returns: `UIAlertController` instance.
     */
    static func retryAlertWithMessage(message: String, retryClosure: () -> Void) -> UIAlertController {

        let title = NSLocalizedString("Error", comment: "")
        let buttonTitle = NSLocalizedString("Retry", comment: "")

        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)

        let doneAction = UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.Default) { _ in
            retryClosure()
        }

        alert.addAction(doneAction)

        return alert
    }
}
