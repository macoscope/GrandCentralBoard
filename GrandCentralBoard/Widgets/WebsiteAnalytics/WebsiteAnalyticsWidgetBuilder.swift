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
        return WebsiteAnalyticsWidget(sources: [])
    }
    
}
