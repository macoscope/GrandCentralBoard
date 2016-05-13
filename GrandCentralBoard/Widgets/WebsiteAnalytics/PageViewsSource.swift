//
//  GoogleAnalyticsSource.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 18.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import GCBCore

enum GoogleAnalyticsSourceError: ErrorType, HavingMessage {
    case DateFormattingError(fromDate: NSDate, daysDifference: Int)

    var message: String {
        switch self {
        case .DateFormattingError:
            return NSLocalizedString("Failed to format date", comment: "")
        }
    }
}


final class PageViewsSource: Asynchronous {

    private let dataProvider: GoogleAnalyticsDataProvider
    private let daysInReport: Int
    private let validPathPrefix: String?


    let interval: NSTimeInterval
    typealias ResultType = Result<[PageViewsRowReport]>
    var sourceType: SourceType {
        return .Momentary
    }

    init(dataProvider: GoogleAnalyticsDataProvider, daysInReport: Int, refreshInterval: NSTimeInterval = 5*60, validPathPrefix: String?) {
        self.dataProvider = dataProvider
        self.interval = refreshInterval
        self.daysInReport = daysInReport
        self.validPathPrefix = validPathPrefix
    }

    func read(closure: (ResultType) -> Void) {
        let now = NSDate()
        guard let reportStartTime = now.dateWith(hour: 0, minute: 0, second: 0)?.dateMinusDays(daysInReport) else {
            closure(.Failure(GoogleAnalyticsSourceError.DateFormattingError(fromDate: now, daysDifference: daysInReport)))
            return
        }

        let validPathPrefix = self.validPathPrefix
        dataProvider.fetchPageViewsReportFromDate(reportStartTime, toDate: now) { result in
            switch result {
            case .Success(let report):
                let pageViews = report.rows.flatMap { row -> PageViewsRowReport? in
                    let pageViewsReport = PageViewsRowReport(analyticsReportRow:row)
                    if let pageViewsReport = pageViewsReport, let prefix = validPathPrefix where !pageViewsReport.hasTitleWithPrefix(prefix) {
                         return nil
                    }
                    return pageViewsReport
                }

                closure(.Success(pageViews))
            case .Failure(let error):
                closure(.Failure(error))
            }
        }
    }
}
