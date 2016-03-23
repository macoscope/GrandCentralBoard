//
//  Created by Oktawian Chojnacki on 31.12.2015.
//  Copyright © 2015 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import GrandCentralBoardCore

private let dataDownloader = DataDownloader()
private let availableBuilders: [WidgetBuilding] = [WatchWidgetBuilder(dataDownloader: dataDownloader), BonusWidgetBuilder(dataDownloader: dataDownloader)]
private let configurationPath = "http://gcb.macoscope.com/configuration.json"
private let localConfig = "configuration"

class LoadingViewController: UIViewController {

    let configurationDownloader = ConfigurationDownloader(dataDownloader: dataDownloader,
                                                                    path: configurationPath,
                                                                builders: availableBuilders)

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchConfiguration()
    }

    private func fetchConfiguration() {
        configurationDownloader.fetchConfiguration { [weak self] result in
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

