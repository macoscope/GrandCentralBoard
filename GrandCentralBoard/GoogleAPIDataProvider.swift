//
//  GoogleAPIDataProvider.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 06.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Alamofire

enum GoogleAPIDataError: ErrorType {
    case AuthorizationError
    case UnderlyingError(NSError)
}

class GoogleAPIDataProvider {

    private let tokenProvider: GoogleTokenProvider
    private var accessToken: String?

    init(tokenProvider: GoogleTokenProvider) {
        self.tokenProvider = tokenProvider
    }

    func request(method: Method, url: URLStringConvertible, parameters: [String: AnyObject]?, completion: Result<AnyObject, GoogleAPIDataError> -> Void) {

        let callRequest: () -> Void =  { [weak self] in
            guard let accessToken = self?.accessToken else {
                completion(.Failure(.AuthorizationError))
                return
            }

            Alamofire.request(method, url, parameters: parameters, headers: ["Authorization": "Token \(accessToken)"])
            .responseJSON { response in
                switch response.result {
                case .Failure(let error): completion(.Failure(.UnderlyingError(error)))
                case .Success(let value): completion(.Success(value))
                }
            }
        }

        if accessToken == nil {
            tokenProvider.accessTokenFromRefreshToken({ [weak self] response in
                switch response {
                case .Failure:
                    completion(.Failure(.AuthorizationError))
                case .Success(let newToken):
                    self?.accessToken = newToken
                    callRequest()
                }

            })
        } else {
            callRequest()
        }
    }
}
