//
//  GoogleAnalyticsSource.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 18.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import GrandCentralBoardCore

enum GoogleAnalyticsSourceError: ErrorType, HavingMessage {
    case DateFormattingError(fromDate: NSDate, daysDifference: Int)

    var message: String {
        switch self {
        case .DateFormattingError:
            return NSLocalizedString("Failed to format date", comment: "")
        }
    }
}


final class GoogleAnalyticsSource : Asynchronous {

    let dataProvider: GoogleAnalyticsDataProvider
    let interval: NSTimeInterval
    let daysInReport: Int

    typealias ResultType = Result<[PageViewsRowReport]>
    var sourceType: SourceType {
        return .Momentary
    }

    init(dataProvider: GoogleAnalyticsDataProvider, daysInReport: Int,
         refreshInterval: NSTimeInterval = 5*60) {
        self.dataProvider = dataProvider
        self.interval = refreshInterval
        self.daysInReport = daysInReport
    }

    func read(closure: (ResultType) -> Void) {
        let now = NSDate()
        guard let reportStartTime = now.dateWith(hour: 0, minute: 0, second: 0)?.dateMinusDays(daysInReport) else {
            closure(.Failure(GoogleAnalyticsSourceError.DateFormattingError(fromDate: now, daysDifference: daysInReport)))
            return
        }

        dataProvider.fetchPageViewsReportFromDate(reportStartTime, toDate: now) { result in
            switch result {
            case .Success(let reports):
                let pageViews = reports.rows.flatMap({ PageViewsRowReport(analyticsReportRow:$0) })
                return closure(.Success(pageViews))
            case .Failure(let error):
                closure(.Failure(error))
            }
        }
    }
}