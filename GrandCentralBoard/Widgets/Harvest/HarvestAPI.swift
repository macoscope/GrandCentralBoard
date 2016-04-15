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
    let numberOfDaysToFetch: Int

    init(account: String, refreshCredentials: TokenRefreshCredentials, downloader: NetworkRequestManager, numberOfDaysToFetch: Int) {
        self.account = account
        self.refreshCredentials = refreshCredentials
        self.downloader = downloader
        self.numberOfDaysToFetch = numberOfDaysToFetch
        self.accessToken = AccessToken(token: "", expiresIn: 0)
    }

    func fetchBillingStats(completion: (Result<[DailyBillingStats]>) -> Void) {
        let request = BillingStatsFetcher(account: account, accessToken: accessToken, downloader: downloader, numberOfDays: numberOfDaysToFetch)
        request.fetchBillingStats(completion)
    }

    func refreshTokenIfNeeded(completion: (Result<AccessToken>) -> Void) {
        if (accessToken.isExpired()) {
            refreshToken(completion)

        } else {
            completion(.Success(accessToken))
        }
    }

    func refreshToken(completion: (Result<AccessToken>) -> Void) {
        let request = AccessTokenFetcher(account: account, refreshCredentials: refreshCredentials, downloader: downloader)
        request.fetchAccessToken() { result in
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
