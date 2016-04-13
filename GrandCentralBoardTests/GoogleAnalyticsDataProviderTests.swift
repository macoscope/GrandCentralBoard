//
//  GoogleAnalyticsDataProviderTests.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 13.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import XCTest
@testable import GrandCentralBoard

private let reportRows = [
    [
        "dimensions" : [ "dim1" ], "metrics" : [
            ["values" : ["12"] ]
        ]
    ],
    [
        "dimensions" : [ "dim2" ], "metrics" : [
            ["values" : ["24"] ]
        ]
    ]
]
private let report = [ "data": [ "rows" :  reportRows] ]
private let responseData = [ "reports" : [ report ] ]

private class TestDataProvider : APIDataProviding {
    func request(method: GrandCentralBoard.Method, url: NSURL, parameters: [String: AnyObject]?, completion: ResultType<AnyObject, APIDataError>.result -> Void) {

        completion(.Success(responseData))
    }
}

class GoogleAnalyticsDataProviderTests : XCTestCase {

    var dataProvider: GoogleAnalyticsDataProvider!

    override func setUp() {
        super.setUp()
        dataProvider = GoogleAnalyticsDataProvider(viewID: "id", dataProvider: TestDataProvider())
    }

    func testResponseDeserialization() {
        let expectation = expectationWithDescription("deserialization")
        dataProvider.fetchPageViewsReportFromDate(NSDate(), toDate: NSDate()) { result in
            switch result {
            case .Success(let report):
                XCTAssertEqual(2, report.rows.count)
                XCTAssertEqual(reportRows[0]["dimensions"]![0], report.rows[0].dimensions[0])
                XCTAssertEqual(reportRows[1]["dimensions"]![0], report.rows[1].dimensions[0])

                //too much effort to get the values from `reportRows` - analytics response is quite complicated
                XCTAssertEqual("12", report.rows[0].values[0])
                XCTAssertEqual("24", report.rows[1].values[0])

            case .Failure(let error):
                XCTFail("Error: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(2.0) { (error) in
            XCTAssertNil(error)
        }
    }

    /** Uncomment and fill with proper credentials if you want to test integration with Google Analytics
    func testIntegration() {
        let expectation = expectationWithDescription("integration")

        let tokenProvider = GoogleTokenProvider(clientID: ,
                                                clientSecret: ,
                                                refreshToken: )
        let apiProvider = GoogleAPIDataProvider(tokenProvider: tokenProvider)
        dataProvider = GoogleAnalyticsDataProvider(viewID: , dataProvider: apiProvider)

        dataProvider.fetchPageViewsReportFromDate(NSDate().dateByAddingTimeInterval(-3600*24*5), toDate: NSDate()) { (result) in
            print("\(result)")
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(10.0) { (error) in
            XCTAssertNil(error)
        }
    }
    */
}
