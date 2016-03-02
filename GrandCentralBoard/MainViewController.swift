//
//  Created by Oktawian Chojnacki on 31.12.2015.
//  Copyright © 2015 Oktawian Chojnacki. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var board: GrandCentralBoard!
    var configuration: Configuration!

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            let autoStack = AutoStack()
            let scheduler = Scheduler()
            board = try GrandCentralBoard(configuration: configuration, scheduler: scheduler, stack: autoStack)
            view = autoStack
        } catch let error  {
            showError(error.alertMessage)
        }
    }

    private func showError(message: String) {

        let title = NSLocalizedString("Error", comment: "")
        let buttonTitle = NSLocalizedString("Retry", comment: "")

        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)

        let doneAction = UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.Default) { [weak self] _ in
            self?.navigationController?.popViewControllerAnimated(true)
        }

        alert.addAction(doneAction)

        presentViewController(alert, animated: true, completion: nil)
    }
}
