//
//  Created by Oktawian Chojnacki on 31.12.2015.
//  Copyright © 2015 Oktawian Chojnacki. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    let configurationPath = "http://gcb.macoscope.com/configuration.json"
    let configurationDownloader = ConfigurationDownloader(dataDownloader: DataDownloader())

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchConfiguration()
    }

    private func fetchConfiguration() {
        configurationDownloader.fetchConfiguration(fromPath: configurationPath) { [weak self] result in
            switch result {
                case .Success(let configuration):
                    let main = Storyboards.Main.instantiate(configuration)
                    self?.navigationController?.pushViewController(main, animated: false)
                case .Failure(let error):
                    self?.showRetryDialogWithMessage(error.userMessage)
            }
        }
    }
}

