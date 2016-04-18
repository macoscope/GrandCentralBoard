//
//  GoogleAnalyticsSource.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 18.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import GrandCentralBoardCore


final class GoogleAnalyticsSource : Asynchronous {

    let dataProvider: GoogleAnalyticsDataProvider
    let interval: NSTimeInterval

    typealias ResultType = Result<[PageViewsRowReport]>
    var sourceType: SourceType {
        return .Momentary
    }

    init(dataProvider: GoogleAnalyticsDataProvider, refreshInterval: NSTimeInterval = 5*60) {
        self.dataProvider = dataProvider
        self.interval = refreshInterval
    }

    func read(closure: (ResultType) -> Void) {
        let now = NSDate()
        let fiveDaysAgo = now.dateWith(hour: 0, minute: 0, second: 0)!.dateMinusDays(5)!
        dataProvider.fetchPageViewsReportFromDate(fiveDaysAgo, toDate: now) { result in
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