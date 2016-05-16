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
    let pageTitle: String
    let visits: Int

    init?(analyticsReportRow row: AnalyticsReportRow) {
        guard row.dimensions.count == 2, let visitCountString = row.values.first, let visitCount = Int(visitCountString) else {
            return nil
        }

        pagePath = row.dimensions[0]
        visits = visitCount

        self.pageTitle = row.dimensions[1]
    }

    static func arrayFromAnalyticsReport(analyticsReport: AnalyticsReport) -> [PageViewsRowReport] {
        return analyticsReport.rows.flatMap { PageViewsRowReport(analyticsReportRow: $0) }
    }
}

extension PageViewsRowReport {

    func hasTitleWithPrefix(prefix: String) -> Bool {
        return pagePath.hasPrefix(prefix) && pagePath.characters.count > prefix.characters.count
    }
}
