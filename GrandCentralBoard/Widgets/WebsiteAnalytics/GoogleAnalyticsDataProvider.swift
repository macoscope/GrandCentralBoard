//
//  GoogleAnalyticsDataProvider.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 13.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import GCBCore


protocol AnalyticsDataProviding {
    func pageViewsReportFromDate(startDate: NSDate, toDate endDate: NSDate,
                                      completion: (Result<AnalyticsReport>) -> Void)
}

final class GoogleAnalyticsDataProvider: AnalyticsDataProviding {
    private static let googleAnalyticsAPIURL = NSURL(string: "https://analyticsreporting.googleapis.com/v4/reports:batchGet?fields=reports")!

    private let dataProvider: APIDataProviding
    private let viewID: String

    init(viewID: String, dataProvider: APIDataProviding) {
        self.viewID = viewID
        self.dataProvider = dataProvider
    }

    func pageViewsReportFromDate(startDate: NSDate, toDate endDate: NSDate,
                                      completion: (Result<AnalyticsReport>) -> Void) {
        let parameters = [
            "viewId": viewID,
            "metrics": [ ["expression": "ga:pageviews"] ],
            "dimensions": [ ["name": "ga:pagePath"], ["name": "ga:pageTitle"] ],
            "dateRanges": [ ["startDate": startDate.yearMonthDayStringForNetwork(), "endDate": endDate.yearMonthDayStringForNetwork()] ],
            "orderBys": [ ["fieldName": "ga:pageviews", "sortOrder": "DESCENDING"] ]
        ]
        dataProvider.request(.POST, url: self.dynamicType.googleAnalyticsAPIURL,
                             parameters: ["reportRequests": [ parameters ]], encoding: .JSON) { (result) in
            switch result {
            case .Success(let json):
                do {
                    try completion(.Success(AnalyticsReport.decode(json)))
                } catch {
                    completion(.Failure(APIDataError.ModelDecodeError(error)))
                }
            case .Failure(let error):
                completion(.Failure(error))
            }
        }
    }
}
