//
//  Created by Oktawian Chojnacki on 31.12.2015.
//  Copyright © 2015 Oktawian Chojnacki. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    private var board: GrandCentralBoard?
    var configuration: Configuration! {
        didSet {
            setUpBoardWithConfiguration(configuration)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBoardWithConfiguration(configuration)
    }

    private func setUpBoardWithConfiguration(configuration: Configuration) {

        guard board == nil else { return }

        do {
            let autoStack = AutoStack()
            let scheduler = Scheduler()
            board = try GrandCentralBoard(configuration: configuration, scheduler: scheduler, stack: autoStack)
            view = autoStack
        } catch let error  {
            showRetryDialogWithMessage(error.userMessage)
        }
    }

    private func showRetryDialogWithMessage(message: String) {
        let alert = UIAlertController.retryAlertWithMessage(message) { [weak self] in
            self?.navigationController?.popViewControllerAnimated(true)
        }

        presentViewController(alert, animated: true, completion: nil)
    }
}
