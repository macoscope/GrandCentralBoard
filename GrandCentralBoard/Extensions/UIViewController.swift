//
//  Created by Oktawian Chojnacki on 10.03.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

public extension UIViewController {
    public func showRetryDialogWithMessage(message: String) {
        let alert = UIAlertController.retryAlertWithMessage(message) { [weak self] in
            self?.navigationController?.popViewControllerAnimated(true)
        }

        presentViewController(alert, animated: true, completion: nil)
    }
}