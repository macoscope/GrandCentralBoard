//
//  PageviewsReport.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 14.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation

protocol PathToTitleTranslating {
    func titleFromPath(path: String) -> String?
}

struct PageViewsRowReport {
    let pagePath: String
    let pageTitle: String
    let visits: Int

    init?(analyticsReportRow row: AnalyticsReportRow, pathToTitleTranslator: PathToTitleTranslating) {
        guard let dimension = row.dimensions.first,
            let value = row.values.first,
            let count = Int(value) else {
                return nil
        }

        pagePath = dimension
        visits = count

        guard let pageTitle = pathToTitleTranslator.titleFromPath(pagePath) else {
            return nil
        }
        self.pageTitle = pageTitle
    }

    static func arrayFromAnalyticsReport(analyticsReport: AnalyticsReport, pathToTitleTranslator: PathToTitleTranslating) -> [PageViewsRowReport] {
        return analyticsReport.rows.flatMap( { PageViewsRowReport(analyticsReportRow: $0, pathToTitleTranslator: pathToTitleTranslator) } )
    }
}
