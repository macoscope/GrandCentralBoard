//
//  GitHubDataProviderTests.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 27.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import XCTest
import Nimble
import RxSwift
import OHHTTPStubs
@testable import GrandCentralBoard


final class GitHubDataProviderTests: XCTestCase {

    private var urlRequest: NSURLRequest!

    private let jsonReposArray: [[String: AnyObject]] = {
        let path = NSBundle(forClass: GitHubDataProviderTests.self).pathForResource("repos", ofType: "json")!
        let jsonData = NSData(contentsOfFile: path)!
        return try! NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as! [[String: AnyObject]]
    }()
    private let pullRequestsArray: [AnyObject] = {
        let path = NSBundle(forClass: GitHubDataProviderTests.self).pathForResource("pull_requests", ofType: "json")!
        let jsonData = NSData(contentsOfFile: path)!
        return try! NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as! [AnyObject]
    }()


    override func setUp() {
        urlRequest = nil

        stub(isPath("/user/repos")) { urlRequest in
            self.urlRequest = urlRequest
            return OHHTTPStubsResponse(JSONObject: self.jsonReposArray, statusCode: 200, headers: ["Content-Type":"application/json"])
        }

        stub(pathStartsWith("/repos/")) { _ in
            return OHHTTPStubsResponse(JSONObject: self.pullRequestsArray, statusCode: 200, headers: ["Content-Type":"application/json"])
        }
    }

    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
    }


    func testAreHeadersValid() {
        let token = "sample_test_token"
        let provider = GitHubDataProvider(accessToken: token)

        waitUntil { done in
            let _ = provider.repositories().subscribeNext { _ in
                expect(self.urlRequest.valueForHTTPHeaderField("Authorization")) == "token \(token)"
                done()
            }
        }
    }

    private func checkReposResponse(repos: [Repository]) {
        expect(repos.count) == jsonReposArray.count

        var reposMap = [String: Repository]()
        repos.forEach { reposMap[$0.fullName] = $0 }
        expect(reposMap.keys.count) == repos.count

        for index in 0..<jsonReposArray.count {
            let fullName = jsonReposArray[index]["full_name"] as! String
            guard let repo = reposMap[fullName] else {
                fail()
                return
            }

            expect(repo.fullName) == fullName
            expect(repo.name) == jsonReposArray[index]["name"] as? String
            expect(repo.openIssuesCount) == jsonReposArray[index]["open_issues_count"] as? Int
            expect(repo.pullRequestsCount) == pullRequestsArray.count
        }
    }

    func testResponseIsValid() {
        let provider = GitHubDataProvider(accessToken: "")
        waitUntil { done in
            let _ = provider.repositoriesWithPRsCount().subscribeNext { (repos) in
                self.checkReposResponse(repos)
                done()
            }
        }
    }
}
