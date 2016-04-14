//
//  FetchAccessTokenRequest.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-14.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
import GrandCentralBoardCore


class FetchAccessTokenRequest {
    let account: String
    let refreshCredentials: TokenRefreshCredentials
    let downloader: NetworkRequestManager

    init(account: String, refreshCredentials: TokenRefreshCredentials, downloader: NetworkRequestManager) {
        self.account = account
        self.refreshCredentials = refreshCredentials
        self.downloader = downloader
    }

    func fetch(completion: (Result<AccessToken>) -> Void) {
        downloader.requestJSON(.POST, url: url, parameters: parameters, headers: headers) { (result: ResultType<AnyObject, NSError>.result) -> Void in
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

    var url: NSURL {
        return NSURL(string: String(format: "https://%@.harvestapp.com/oauth2/token", account))!
    }

    var parameters: [String: String] {
        return ["refresh_token": refreshCredentials.refreshToken,
                "client_id": refreshCredentials.clientID,
                "client_secret": refreshCredentials.clientSecret,
                "grant_type": "refresh_token"]
    }

    var headers: [String: String] {
        return ["ContentType": "application/x-www-form-urlencoded"]
    }
}
