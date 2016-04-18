//
//  BillingUserListFetcher.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-18.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
import GrandCentralBoardCore


class BillingUserListFetcher {
    private let account: String
    private let accessToken: AccessToken
    private let downloader: NetworkRequestManager

    init(account: String, accessToken: AccessToken, downloader: NetworkRequestManager) {
        self.account = account
        self.accessToken = accessToken
        self.downloader = downloader
    }

    func fetchUserList(completion: (Result<[BillingUserID]>) -> Void) {
        downloader.requestJSON(.GET, url: url, parameters: [:], headers: headers, encoding: .URL) { result in
            switch (result) {
            case .Success(let json):
                do {
                    let userIDs = try BillingUserList.decode(json).userIDs
                    completion(.Success(userIDs))

                } catch let error {
                    completion(.Failure(error))
                }
            case .Failure(let error):
                completion(.Failure(error))
            }
        }
    }

    private var url: NSURL {
        return NSURL(string: String(format: "https://%@.harvestapp.com/people", account))!
    }

    private var headers: [String: String] {
        return ["Authorization": "Bearer " + accessToken.token, "Accept": "application/json"]
    }
}
