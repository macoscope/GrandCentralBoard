//
//  Created by Oktawian Chojnacki on 31.12.2015.
//  Copyright © 2015 Oktawian Chojnacki. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchConfiguration()
    }

    private func fetchConfiguration() {
        Configuration.fetchConfiguration { [weak self] result in
            switch result {
                case .Success(let configuration):
                    let main = Storyboards.Main.instantiate(configuration)
                    self?.navigationController?.pushViewController(main, animated: true)
                case .Failure(let error):
                    self?.showRetryDialogWithMessage(error.userMessage)
            }
        }
    }

    private func showRetryDialogWithMessage(message: String) {
        let alert = UIAlertController.retryAlertWithMessage(message) { [weak self] in
            self?.fetchConfiguration()
        }

        presentViewController(alert, animated: true, completion: nil)
    }
}

