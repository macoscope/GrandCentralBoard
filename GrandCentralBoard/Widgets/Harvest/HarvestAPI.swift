//
//  HarvestAPI.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-12.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import GrandCentralBoardCore


final class HarvestAPI {
    let account: String
    let refreshCredentials: TokenRefreshCredentials
    let downloader: NetworkRequestManager
    var accessToken: AccessToken

    init(account: String, refreshCredentials: TokenRefreshCredentials, downloader: NetworkRequestManager) {
        self.account = account
        self.refreshCredentials = refreshCredentials
        self.downloader = downloader
        self.accessToken = AccessToken(token: "", expiresIn: 0)
    }

    func fetchBillingStats(completion: (Result<[DailyBillingStats]>) -> Void) {
        let numberOfDaysToFetch = 6

        let request = FetchBillingStatsRequest(account: account, accessToken: accessToken, downloader: downloader, numberOfDays: numberOfDaysToFetch)
        request.fetch(completion)
    }

    func refreshTokenIfNeeded(completion: (Result<AccessToken>) -> Void) {
        if (accessToken.isExpired()) {
            refreshToken(completion)

        } else {
            completion(.Success(accessToken))
        }
    }

    func refreshToken(completion: (Result<AccessToken>) -> Void) {
        let request = FetchAccessTokenRequest(account: account, refreshCredentials: refreshCredentials, downloader: downloader)
        request.fetch() { result in
            switch (result) {
            case .Success(let accessToken):
                self.accessToken = accessToken
                completion(result)

            case .Failure(_):
                completion(result)
            }
        }
    }
}
