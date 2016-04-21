//
//  Created by Oktawian Chojnacki on 31.12.2015.
//  Copyright © 2015 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import GrandCentralBoardCore


final class MainViewController: UIViewController {

    private let autoStack = AutoStack()
    private let scheduler = Scheduler()
    private lazy var board: GrandCentralBoard = { GrandCentralBoard(scheduler: self.scheduler, stack: self.autoStack) }()

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
        view = autoStack
        do {
            try board.configure(configuration)
        } catch let error {
            showRetryDialogWithMessage(error.userMessage) { [weak self] in
                self?.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
}
