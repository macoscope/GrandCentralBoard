//
//  SlackRestAPIProviderTests.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 11.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import XCTest
import Nimble
import RxSwift
import OHHTTPStubs
@testable import GrandCentralBoard


final class SlackRestAPIProviderTests: XCTestCase {

    private var urlRequest: NSURLRequest!

    private let rtmStartResponse: [[String: AnyObject]] = {
        let path = NSBundle(forClass: SlackRestAPIProviderTests.self).pathForResource("repos", ofType: "json")!
        let jsonData = NSData(contentsOfFile: path)!
        return try! NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as! [[String: AnyObject]]
    }()

    private let websocketURL = "wss://some.slack.url/websocket/123"

    override func setUp() {
        urlRequest = nil
        let rtmStartPath = SlackTarget.GetWebsocketAddress.baseURL.URLByAppendingPathComponent(SlackTarget.GetWebsocketAddress.path).path!

        stub(isPath(rtmStartPath)) { urlRequest in
            self.urlRequest = urlRequest
            return OHHTTPStubsResponse(JSONObject: ["ok": true, "url": self.websocketURL], statusCode: 200, headers: nil)
        }
    }

    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
    }

    func testWebsocketURLFetch() {
        let provider = SlackRestAPIProvider(accessToken: "")
        waitUntil { done in
            let _ = provider.websocketAddress().subscribeNext { url in
                expect(url.URLString) == self.websocketURL
                done()
            }
        }
    }

    func testTokenIsProvided() {
        let token = "just_test_token"
        let provider = SlackRestAPIProvider(accessToken: token)
        waitUntil { done in
            let _ = provider.websocketAddress().subscribeNext { _ in
                expect(self.urlRequest.URL?.query) == "token=\(token)"
                done()
            }
        }
    }
}
