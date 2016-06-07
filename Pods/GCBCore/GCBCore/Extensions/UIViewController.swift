//
//  Created by Oktawian Chojnacki on 10.03.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

public extension UIViewController {

    /**
     Show `UIAlertController` with error message and just one `Retry` button calling closure on tap.

     - parameter message:      error message.
     - parameter retryClosure: this closure will be called when user taps `Retry` button.
     */
    public func showRetryDialogWithMessage(message: String, retryClosure: (() -> Void)) {
        let alert = UIAlertController.retryAlertWithMessage(message) {
            retryClosure()
        }

        presentViewController(alert, animated: true, completion: nil)
    }
}
