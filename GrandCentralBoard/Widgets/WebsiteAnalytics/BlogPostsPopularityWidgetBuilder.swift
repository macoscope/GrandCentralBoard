//
//  WebsiteAnalyticsWidgetBuilder.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 13/04/16.
//

import Alamofire
import GCBCore
import GCBUtilities

final class BlogPostsPopularityWidgetBuilder: WidgetBuilding {

    var name = "blogPostsPopularity"

    func build(settings: AnyObject) throws -> WidgetControlling {
        let settings = try WebsiteAnalyticsSettings.decode(settings)
        let tokenProvider = GoogleTokenProvider(clientID: settings.clientID,
                                                clientSecret: settings.clientSecret,
                                                refreshToken: settings.refreshToken)
        let apiDataProvider = GoogleAPIDataProvider(tokenProvider: tokenProvider, networkRequestManager: Manager())
        let analyticsDataProvider = GoogleAnalyticsDataProvider(viewID: settings.viewID,
                                                                dataProvider: apiDataProvider)

        let googleAnalyticsSource = PageViewsSource(dataProvider: analyticsDataProvider,
                                                          daysInReport: settings.daysInReport,
                                                          refreshInterval: NSTimeInterval(settings.refreshInterval),
                                                          validPathPrefix: settings.validPathPrefix)

        return WebsiteAnalyticsWidget(sources: [googleAnalyticsSource])
    }

}
