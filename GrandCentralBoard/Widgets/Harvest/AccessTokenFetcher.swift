//
//  AccessTokenFetcher.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-14.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
import GrandCentralBoardCore


class AccessTokenFetcher {
    private let account: String
    private let refreshCredentials: TokenRefreshCredentials
    private let downloader: NetworkRequestManager

    init(account: String, refreshCredentials: TokenRefreshCredentials, downloader: NetworkRequestManager) {
        self.account = account
        self.refreshCredentials = refreshCredentials
        self.downloader = downloader
    }

    func fetchAccessToken(completion: (Result<AccessToken>) -> Void) {
        downloader.requestJSON(.POST, url: url, parameters: parameters, headers: headers, encoding: .URL) { result in
            switch (result) {
            case .Success(let json):
                do {
                    let accessToken = try AccessToken.decode(json)
                    completion(.Success(accessToken))

                } catch let error {
                    completion(.Failure(error))
                }
            case .Failure(let error):
                completion(.Failure(error))
            }
        }
    }

    private var url: NSURL {
        return NSURL(string: String(format: "https://%@.harvestapp.com/oauth2/token", account))!
    }

    private var parameters: [String: String] {
        return ["refresh_token": refreshCredentials.refreshToken,
                "client_id": refreshCredentials.clientID,
                "client_secret": refreshCredentials.clientSecret,
                "grant_type": "refresh_token"]
    }

    private var headers: [String: String] {
        return ["ContentType": "application/x-www-form-urlencoded"]
    }
}
