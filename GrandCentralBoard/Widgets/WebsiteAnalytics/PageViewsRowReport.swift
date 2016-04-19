//
//  PageviewsReport.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 14.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation

struct PageViewsRowReport {
    let pagePath: String
    let visits: Int

    init?(analyticsReportRow row: AnalyticsReportRow) {
        guard let dimension = row.dimensions.first,
            let value = row.values.first,
            let count = Int(value) else {
                return nil
        }

        pagePath = dimension
        visits = count
    }

    static func arrayFromAnalyticsReport(analyticsReport: AnalyticsReport) -> [PageViewsRowReport] {
        return analyticsReport.rows.flatMap( { PageViewsRowReport(analyticsReportRow: $0) } )
    }
}

extension PageViewsRowReport {
    var isBlogPostPage: Bool {
        return pagePath.hasPrefix("/blog/")
    }

    var pageTitle: String {
        return pagePath.stringByReplacingOccurrencesOfString("/blog/", withString: "")
            .stringByReplacingOccurrencesOfString("-", withString: " ")
            .stringByReplacingOccurrencesOfString("/", withString: "")
            .capitalizedString
    }
}
