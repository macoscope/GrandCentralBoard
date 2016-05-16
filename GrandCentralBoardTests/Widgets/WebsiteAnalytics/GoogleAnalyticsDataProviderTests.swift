//
//  GoogleAnalyticsDataProviderTests.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 13.04.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import XCTest
@testable import GrandCentralBoard
import GCBCore
import GCBUtilities


private let reportRows = [
    [
        "dimensions" : [ "dim1", "page_title_1" ], "metrics" : [
            ["values" : ["12"] ]
        ]
    ],
    [
        "dimensions" : [ "dim2", "page_title_2" ], "metrics" : [
            ["values" : ["24"] ]
        ]
    ]
]
private let report = [ "data": [ "rows" :  reportRows] ]
private let responseData = [ "reports" : [ report ] ]

private class TestDataProvider: APIDataProviding {
    func request(method: GCBUtilities.Method, url: NSURL, parameters: [String: AnyObject]?,
                 encoding: ParameterEncoding, completion: Result<AnyObject> -> Void) {

        completion(.Success(responseData))
    }
}


class GoogleAnalyticsDataProviderTests: XCTestCase {

    var dataProvider: GoogleAnalyticsDataProvider!

    override func setUp() {
        super.setUp()
        dataProvider = GoogleAnalyticsDataProvider(viewID: "id", dataProvider: TestDataProvider())
    }

    func testResponseDeserialization() {
        let expectation = expectationWithDescription("deserialization")
        dataProvider.pageViewsReportFromDate(NSDate(), toDate: NSDate()) { result in
            switch result {
            case .Success(let report):
                let pageViewsReports = PageViewsRowReport.arrayFromAnalyticsReport(report)

                XCTAssertEqual(2, pageViewsReports.count)
                XCTAssertEqual(reportRows[0]["dimensions"]![0], pageViewsReports[0].pagePath)
                XCTAssertEqual(reportRows[1]["dimensions"]![0], pageViewsReports[1].pagePath)
                XCTAssertEqual(reportRows[0]["dimensions"]![1], pageViewsReports[0].pageTitle)
                XCTAssertEqual(reportRows[1]["dimensions"]![1], pageViewsReports[1].pageTitle)

                //too much effort to get the values from `reportRows` dictionary - analytics response is quite complicated
                XCTAssertEqual(12, pageViewsReports[0].visits)
                XCTAssertEqual(24, pageViewsReports[1].visits)

            case .Failure(let error):
                XCTFail("Error: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(2.0) { (error) in
            XCTAssertNil(error)
        }
    }
}
