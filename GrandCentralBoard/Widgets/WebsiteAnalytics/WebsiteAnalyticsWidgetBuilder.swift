//
//  WebsiteAnalyticsWidgetBuilder.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 13/04/16.
//

import GrandCentralBoardCore


final class WebsiteAnalyticsWidgetBuilder : WidgetBuilding {

    var name = "websiteAnalytics"

    func build(settings: AnyObject) throws -> Widget {
        let settings = try WebsiteAnalyticsSettings.decode(settings)
        let tokenProvider = GoogleTokenProvider(clientID: settings.clientID,
                                                clientSecret: settings.clientSecret,
                                                refreshToken: settings.refreshToken)
        let apiDataProvider = GoogleAPIDataProvider(tokenProvider: tokenProvider)
        let analyticsDataProvider = GoogleAnalyticsDataProvider(viewID: settings.viewID,
                                                                dataProvider: apiDataProvider)
        let googleAnalyticsSource = GoogleAnalyticsSource(dataProvider: analyticsDataProvider,
                                                          daysInReport: settings.daysInReport,
                                                          refreshInterval: NSTimeInterval(settings.refreshInterval))

        return WebsiteAnalyticsWidget(sources: [googleAnalyticsSource])
    }
    
}
