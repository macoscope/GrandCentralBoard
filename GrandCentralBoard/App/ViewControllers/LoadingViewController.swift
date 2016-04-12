//
//  Created by Oktawian Chojnacki on 31.12.2015.
//  Copyright © 2015 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import GrandCentralBoardCore

private let dataDownloader = DataDownloader()
private let availableBuilders: [WidgetBuilding] = [WatchWidgetBuilder(dataDownloader: dataDownloader), BonusWidgetBuilder(dataDownloader: dataDownloader), GoogleCalendarWatchWidgetBuilder()]
private let useLocal = debugBuild

class LoadingViewController: UIViewController {

    lazy var configurationFetching: ConfigurationFetching = {

        if useLocal {
            return LocalConfigurationLoader(configFileName: localConfigurationFileName, availableBuilders: availableBuilders)
        }

        return ConfigurationDownloader(dataDownloader: dataDownloader, path: configurationPath, builders: availableBuilders)
    }()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchConfiguration()
    }

    private func fetchConfiguration() {
        configurationFetching.fetchConfiguration { [weak self] result in
            switch result {
                case .Success(let configuration):
                    let main = Storyboards.Main.instantiate(configuration)
                    self?.navigationController?.pushViewController(main, animated: false)
                case .Failure(let error):
                    self?.showRetryDialogWithMessage(error.userMessage) { [weak self] in
                        self?.fetchConfiguration()
                    }
            }
        }
    }
}

