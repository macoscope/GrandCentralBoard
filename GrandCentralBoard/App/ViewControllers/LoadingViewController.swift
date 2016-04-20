//
//  Created by Oktawian Chojnacki on 31.12.2015.
//  Copyright © 2015 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import GrandCentralBoardCore


let shouldLoadBundledConfig = NSBundle.alwaysUseLocalConfigurationFile || NSProcessInfo.loadBundledConfig

class LoadingViewController: UIViewController {

    private let dataDownloader = DataDownloader()

    private lazy var availableBuilders: [WidgetBuilding] = [
        WatchWidgetBuilder(dataDownloader: self.dataDownloader),
        BonusWidgetBuilder(dataDownloader: self.dataDownloader),
        GoogleCalendarWatchWidgetBuilder(),
        HarvestWidgetBuilder(),
        ImageWidgetBuilder(dataDownloader: self.dataDownloader),
        BlogPostsPopularityWidgetBuilder()
    ]

    private lazy var configurationFetching: ConfigurationFetching = {

        if shouldLoadBundledConfig {
            return LocalConfigurationLoader(configFileName: NSBundle.localConfigurationFileName,
                                         availableBuilders: self.availableBuilders)
        }

        return ConfigurationDownloader(dataDownloader: self.dataDownloader,
                                                 path: NSBundle.remoteConfigurationPath,
                                             builders: self.availableBuilders)
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
