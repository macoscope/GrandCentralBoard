//
//  GoogleTokenProvider.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 06.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Alamofire
import GCBCore

public enum RefreshTokenError: ErrorType {
    case FailedResponseParsing
    case UnderlyingError(NSError)
}

public protocol OAuth2TokenProviding {
    func accessTokenFromRefreshToken(completion: (GCBCore.Result<AccessToken>) -> Void)
}

private let googleRefreshTokenURL = "https://accounts.google.com/o/oauth2/token"

public final class GoogleTokenProvider: OAuth2TokenProviding {

    private let clientID, clientSecret: String
    private let refreshToken: String
    private let refreshURL: URLStringConvertible

    public init(clientID: String, clientSecret: String, refreshToken: String, refreshURL: URLStringConvertible = googleRefreshTokenURL) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.refreshToken = refreshToken
        self.refreshURL = refreshURL
    }

    public func accessTokenFromRefreshToken(completion: (GCBCore.Result<AccessToken>) -> Void) {
        Alamofire.request(.POST, googleRefreshTokenURL, parameters: [
            "client_id": clientID,
            "client_secret": clientSecret,
            "refresh_token": refreshToken,
            "grant_type": "refresh_token"
            ]).responseJSON { response in
                switch response.result {
                case .Failure(let error): completion(.Failure(RefreshTokenError.UnderlyingError(error)))
                case .Success(let json):
                    if let tokenResponse = try? AccessToken.decode(json) {
                        completion(.Success(tokenResponse))
                    } else {
                        completion(.Failure(RefreshTokenError.FailedResponseParsing))
                    }
                }
        }
    }
}
