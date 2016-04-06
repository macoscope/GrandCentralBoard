//
//  GoogleTokenProvider.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 06.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Alamofire

enum GoogleRefreshTokenError: ErrorType {
    case FailedResponseParsing
    case UnderlyingError(NSError)
}

class GoogleTokenProvider {

    private let googleRefreshTokenURL = "https://accounts.google.com/o/oauth2/token"

    private let clientID, clientSecret: String
    private let refreshToken: String

    init(clientID: String, clientSecret: String, refreshToken: String) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.refreshToken = refreshToken
    }

    func accessTokenFromRefreshToken(completion: (Result<String, GoogleRefreshTokenError>) -> Void) {
        Alamofire.request(.POST, googleRefreshTokenURL, parameters: [
            "client_id": clientID,
            "client_secret": clientSecret,
            "refresh_token": refreshToken,
            "grant_type": "refresh_token"
            ]).responseJSON { response in
                switch response.result {
                case .Failure(let error): completion(.Failure(.UnderlyingError(error)))
                case .Success(let json):
                    if let token = (json as? NSDictionary)?.valueForKey("access_token") as? String {
                        completion(.Success(token))
                    } else {
                        completion(.Failure(.FailedResponseParsing))
                    }
                }
        }
    }
}
