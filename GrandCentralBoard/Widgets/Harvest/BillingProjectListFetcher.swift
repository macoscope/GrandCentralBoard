//
//  BillingProjectListFetcher.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-18.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
import GrandCentralBoardCore


class BillingProjectListFetcher {
    private let account: String
    private let accessToken: AccessToken
    private let downloader: NetworkRequestManager

    init(account: String, accessToken: AccessToken, downloader: NetworkRequestManager) {
        self.account = account
        self.accessToken = accessToken
        self.downloader = downloader
    }

    func fetchProjectList(completion: (Result<[BillingProjectID]>) -> Void) {
        downloader.requestJSON(.GET, url: url, parameters: [:], headers: headers, encoding: .URL) { result in
            switch result {
            case .Success(let json):
                do {
                    let projectIDs = try BillingProjectList.decode(json).projectIDs
                    completion(.Success(projectIDs))

                } catch let error {
                    completion(.Failure(error))
                }
            case .Failure(let error):
                completion(.Failure(error))
            }
        }
    }

    private var url: NSURL {
        return NSURL(string: String(format: "https://%@.harvestapp.com/projects", account))!
    }

    private var headers: [String: String] {
        return ["Authorization": "Bearer " + accessToken.token, "Accept": "application/json"]
    }
}
