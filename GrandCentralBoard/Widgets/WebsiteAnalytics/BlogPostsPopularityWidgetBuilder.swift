//
//  WebsiteAnalyticsWidgetBuilder.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 13/04/16.
//

import GrandCentralBoardCore


private class BlogPostTitleTranslator: PathToTitleTranslating {
    private let pathPrefix: String?

    init(pathPrefix: String?) {
        self.pathPrefix = pathPrefix
    }

    private func titleFromPath(path: String) -> String? {
        var path = path
        if let pathPrefix = pathPrefix {
            guard path.hasPrefix(pathPrefix) else { return nil }
            path = path.substringFromIndex(path.startIndex.advancedBy(pathPrefix.characters.count))
        }

        return path.stringByReplacingOccurrencesOfString("-", withString: " ")
            .stringByReplacingOccurrencesOfString("/", withString: "")
            .capitalizedString
    }
}

final class BlogPostsPopularityWidgetBuilder: WidgetBuilding {

    var name = "blogPostsPopularity"

    func build(settings: AnyObject) throws -> Widget {
        let settings = try WebsiteAnalyticsSettings.decode(settings)
        let tokenProvider = GoogleTokenProvider(clientID: settings.clientID,
                                                clientSecret: settings.clientSecret,
                                                refreshToken: settings.refreshToken)
        let apiDataProvider = GoogleAPIDataProvider(tokenProvider: tokenProvider)
        let analyticsDataProvider = GoogleAnalyticsDataProvider(viewID: settings.viewID,
                                                                dataProvider: apiDataProvider)

        let pathToTitleTranslator = BlogPostTitleTranslator(pathPrefix: settings.validPathPrefix)

        let googleAnalyticsSource = PageViewsSource(dataProvider: analyticsDataProvider,
                                                          daysInReport: settings.daysInReport,
                                                          refreshInterval: NSTimeInterval(settings.refreshInterval),
                                                          pathToTitleTranslator: pathToTitleTranslator)

        return WebsiteAnalyticsWidget(sources: [googleAnalyticsSource])
    }

}
