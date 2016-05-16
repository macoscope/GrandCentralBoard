//
//  PageViewsSourceTests.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 16.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import XCTest
import Nimble
import GCBCore
@testable import GrandCentralBoard


private final class TestAnalyticsDataProvider: AnalyticsDataProviding {

    private let result: Result<AnalyticsReport>

    init(result: Result<AnalyticsReport>) {
        self.result = result
    }

    func pageViewsReportFromDate(startDate: NSDate, toDate endDate: NSDate, completion: (Result<AnalyticsReport>) -> Void) {
        completion(result)
    }
}

final class PageViewsSourceTests: XCTestCase {

    func testWithValidPrefixPath() {
        let pathPrefix = "/testPathPrefix/"
        let reportRows: [AnalyticsReportRow] = [
            AnalyticsReportRow(dimensions: ["\(pathPrefix)/somePathWithPrefix", "PageTitle1"], values: ["149"]),
            AnalyticsReportRow(dimensions: ["somePathWithoutPrefix", "PageTitle2"], values: ["149"]),
        ]

        let dataProvider = TestAnalyticsDataProvider(result: .Success(AnalyticsReport(rows: reportRows)))

        let source = PageViewsSource(dataProvider: dataProvider, daysInReport: 0, refreshInterval: 0, validPathPrefix: pathPrefix)

        waitUntil { done in
            source.read({ result in
                switch result {
                case .Failure(let error): fail("\(error)")
                case .Success(let data):
                    expect(data.count) == 1
                    expect(data[0].pageTitle) == reportRows[0].dimensions[1]
                }
                done()
            })
        }
    }

    func testWithoutValidPrefixPath() {
        let reportRows: [AnalyticsReportRow] = [
            AnalyticsReportRow(dimensions: ["/somePath/somePathWithPrefix", "PageTitle1"], values: ["149"]),
            AnalyticsReportRow(dimensions: ["/somePathWithoutPrefix", "PageTitle2"], values: ["149"]),
            ]

        let dataProvider = TestAnalyticsDataProvider(result: .Success(AnalyticsReport(rows: reportRows)))

        let source = PageViewsSource(dataProvider: dataProvider, daysInReport: 0, refreshInterval: 0, validPathPrefix: nil)

        waitUntil { done in
            source.read({ result in
                switch result {
                case .Failure(let error): fail("\(error)")
                case .Success(let data):
                    expect(data.count) == 2
                    expect(data[0].pageTitle) == reportRows[0].dimensions[1]
                    expect(data[1].pageTitle) == reportRows[1].dimensions[1]
                }
                done()
            })
        }
    }
}
