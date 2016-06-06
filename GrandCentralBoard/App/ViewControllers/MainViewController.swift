//
//  Created by Oktawian Chojnacki on 31.12.2015.
//  Copyright © 2015 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import GCBCore


private let shouldLoadBundledConfig = NSBundle.alwaysUseLocalConfigurationFile || NSProcessInfo.loadBundledConfig
private let configRefreshInterval: NSTimeInterval = 60

final class MainViewController: UIViewController {

    private let autoStack = AutoStack()
    private let scheduler = Scheduler()
    private let dataDownloader = DataDownloader()
    private let configurationRefresher: ConfigurationRefresher
    private let configurationFetching: ConfigurationFetching
    private let boardController: GrandCentralBoardController

    required init?(coder aDecoder: NSCoder) {

        let availableBuilders: [WidgetBuilding] = [
            WatchWidgetBuilder(dataDownloader: dataDownloader),
            BonusWidgetBuilder(dataDownloader: dataDownloader),
            GoogleCalendarWatchWidgetBuilder(),
            HarvestWidgetBuilder(),
            ImageWidgetBuilder(dataDownloader: dataDownloader),
            BlogPostsPopularityWidgetBuilder(),
            SlackWidgetBuilder(),
            GitHubWidgetBuilder(),
            AnalogClockWidgetBuilder()
        ]

        if shouldLoadBundledConfig {
            configurationFetching = LocalConfigurationLoader(configFileName: NSBundle.localConfigurationFileName,
                                            availableBuilders: availableBuilders)
        } else {
            configurationFetching = ConfigurationDownloader(dataDownloader: dataDownloader,
                                                            path: NSBundle.remoteConfigurationPath,
                                                            builders: availableBuilders)
        }

        boardController = GrandCentralBoardController(scheduler: self.scheduler, stack: self.autoStack)

        configurationRefresher = ConfigurationRefresher(interval: configRefreshInterval,
                                                        configuree: boardController,
                                                        fetcher: configurationFetching)

        super.init(coder: aDecoder)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        view = autoStack

        configurationRefresher.start()
    }
}
