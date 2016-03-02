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
                    self?.showError(error.alertMessage)
            }
        }
    }

    private func showError(message: String) {

        let title = NSLocalizedString("Error", comment: "")
        let buttonTitle = NSLocalizedString("Retry", comment: "")

        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)

        let doneAction = UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.Default) { [weak self] _ in
            self?.fetchConfiguration()
        }

        alert.addAction(doneAction)

        presentViewController(alert, animated: true, completion: nil)
    }
}

