//
//  GitHubDataProviderTests.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 27.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import XCTest
import Nimble
@testable import GrandCentralBoard


private let jsonReposArray: [[String: AnyObject]] = {
    let path = NSBundle(forClass: TestNetworkRequestManager.self).pathForResource("repos", ofType: "json")!
    let jsonData = NSData(contentsOfFile: path)!
    return try! NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as! [[String: AnyObject]]
}()

private class TestNetworkRequestManager: NetworkRequestManager {

    var usedHeaders = [String: String]()

    private func requestJSON(method: GrandCentralBoard.Method, url: NSURL,
                             parameters: [String : AnyObject]?, headers: [String : String]?,
                             encoding: ParameterEncoding,
                             completion: (ResultType<AnyObject, NSError>.result) -> Void) {

        usedHeaders = headers ?? [:]
        completion(.Success(jsonReposArray))
    }
}

final class GitHubDataProviderTests: XCTestCase {

    func testAreHeadersValid() {
        let token = "token"
        let networkRequestManager = TestNetworkRequestManager()
        let provider = GitHubDataProvider(networkRequestManager: networkRequestManager, accessToken: token)

        waitUntil { done in
            provider.requestRepositories({ result in

                switch result {
                case .Success:
                    expect(networkRequestManager.usedHeaders["Authorization"]) == "token \(token)"
                case .Failure(let error):
                    fail("Failed with error: \(error)")
                }
                done()
            })
        }
    }

    func checkReposResponse(repos: [Repository]) {
        expect(repos.count) == jsonReposArray.count
        for index in 0..<repos.count {
            expect(repos[index].fullName) == jsonReposArray[index]["full_name"] as? String
            expect(repos[index].name) == jsonReposArray[index]["name"] as? String
            expect(repos[index].openIssuesCount) == jsonReposArray[index]["open_issues_count"] as? Int
        }
    }

    func testResponseIsValid() {
        let provider = GitHubDataProvider(networkRequestManager: TestNetworkRequestManager(), accessToken: "")

        waitUntil { done in
            provider.requestRepositories({ result in

                switch result {
                case .Success(let repos):
                    self.checkReposResponse(repos)
                case .Failure(let error):
                    fail("Failed with error: \(error)")
                }
                done()
            })
        }
    }
}
