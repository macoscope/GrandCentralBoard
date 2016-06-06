//
//  HarvestAPI.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-12.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import GCBCore
import GCBUtilities


protocol HarvestAPIProviding {
    func fetchBillingStatsForDates(dates: BillableDates, completion: (Result<[DailyBillingStats]>) -> Void)
    func refreshTokenIfNeeded(completion: (Result<AccessToken>) -> Void)
}

final class HarvestAPI: HarvestAPIProviding {
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

    func fetchBillingStatsForDates(dates: BillableDates, completion: (Result<[DailyBillingStats]>) -> Void) {
        let request = BillingStatsFetcher(account: account, accessToken: accessToken, downloader: downloader, dates: dates)
        request.fetchBillingStats(completion)
    }

    func refreshTokenIfNeeded(completion: (Result<AccessToken>) -> Void) {
        if accessToken.isExpired() {
            refreshToken(completion)

        } else {
            completion(.Success(accessToken))
        }
    }

    func refreshToken(completion: (Result<AccessToken>) -> Void) {
        let request = AccessTokenFetcher(account: account, refreshCredentials: refreshCredentials, downloader: downloader)
        request.fetchAccessToken() { result in
            switch result {
            case .Success(let accessToken):
                self.accessToken = accessToken
                fallthrough
            default:
                completion(result)
            }
        }
    }
}
