//
//  GoogleIntegrationTest.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 07.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import XCTest
@testable import GrandCentralBoard
import GCBCore
import GCBUtilities


class TestTokenProvider: OAuth2TokenProviding {

    let expireInterval: Int
    let token: String

    var timesCalled = 0

    init(token: String, expireInterval: Int) {
        self.token = token
        self.expireInterval = expireInterval
    }

    func accessTokenFromRefreshToken(completion: (Result<AccessToken>) -> Void) {
        timesCalled += 1
        completion(.Success(AccessToken(token: "token", expiresIn: expireInterval)))
    }
}

class TestRequestManager: NetworkRequestManager {

    let token: String

    init(token: String) {
        self.token = token
    }

    func requestJSON(method: GCBUtilities.Method,
                     url: NSURL,
                     parameters: [String : AnyObject]? = nil,
                     headers: [String : String]? = nil,
                     encoding: ParameterEncoding,
                     completion: (Result<AnyObject>) -> Void) {

        XCTAssertEqual("Bearer \(token)", headers!["Authorization"])
        completion(.Success(["result" : 0] as NSDictionary))
    }
}

class APIDataProviderTests: XCTestCase {

    var tokenProvider: TestTokenProvider!
    var dataProvider: GoogleAPIDataProvider!

    override func setUp() {
        super.setUp()
        let token = "token"
        tokenProvider = TestTokenProvider(token: token, expireInterval: 1)
        dataProvider = GoogleAPIDataProvider(tokenProvider: tokenProvider, networkRequestManager: TestRequestManager(token: token))
    }

    func testTokenRefresh() {
        let expectationFirstRequest = expectationWithDescription("firstRequest")
        let expectationSecondRequest = expectationWithDescription("secondRequest")
        let expectationThirdRequest = expectationWithDescription("thirdRequest")

        let url = NSURL(string: "https://www.macoscope.com")!

        let requestWithExpectation = { [unowned self] (expectation: XCTestExpectation) in
            self.dataProvider.request(.GET, url: url, parameters: nil) { result in
                if case .Failure = result {
                    XCTFail("result failure")
                }
                expectation.fulfill()
            }
        }

        requestWithExpectation(expectationFirstRequest)

        let backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        var delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(tokenProvider.expireInterval) * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, backgroundQueue) { requestWithExpectation(expectationSecondRequest) }

        delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(tokenProvider.expireInterval) * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, backgroundQueue) { requestWithExpectation(expectationThirdRequest) }

        waitForExpectationsWithTimeout(4 * Double(tokenProvider.expireInterval)) { [unowned self] (error) in
            XCTAssert(error == nil)
            XCTAssertEqual(2, self.tokenProvider.timesCalled)
        }
    }
}
