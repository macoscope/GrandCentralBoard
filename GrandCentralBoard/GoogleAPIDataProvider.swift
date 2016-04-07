//
//  GoogleAPIDataProvider.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 06.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Alamofire
import Operations

enum APIDataError : ErrorType {
    case AuthorizationError
    case UnderlyingError(NSError)
}

final class GoogleAPIDataProvider {

    private let tokenProvider: OAuthTokenProvider
    private var accessToken: AccessToken?

    private let operationQueue = OperationQueue()

    init(tokenProvider: OAuthTokenProvider) {
        self.tokenProvider = tokenProvider
    }

    private func refreshTokenOperation() -> Operation {
        let refreshTokenOperation = BlockOperation(block: { [weak self] (continueWithError) in
            guard let strongSelf = self else {
                continueWithError(error: nil)
                return
            }

            strongSelf.tokenProvider.accessTokenFromRefreshToken({ result in
                switch result {
                case .Failure(let error):
                    continueWithError(error: error)
                case .Success(let value):
                    self?.accessToken = value
                    continueWithError(error: nil)
                }
            })
            })
        return refreshTokenOperation
    }

    func request(method: Alamofire.Method, url: URLStringConvertible, parameters: [String: AnyObject]?, completion: Result<AnyObject, APIDataError> -> Void) {

        let fetchDataOperation = BlockOperation (block: { [weak self] (continueWithError) in
            guard let strongSelf = self, let accessToken = strongSelf.accessToken?.token else {
                completion(.Failure(.AuthorizationError))
                continueWithError(error: APIDataError.AuthorizationError)
                return
            }

            Alamofire.request(method, url, parameters: parameters, headers: ["Authorization": "Bearer \(accessToken)"])
                .responseJSON { response in
                    switch response.result {
                    case .Failure(let error): completion(.Failure(.UnderlyingError(error)))
                    case .Success(let value): completion(.Success(value))
                    }
            }
        })

        if accessToken == nil || NSDate() < accessToken!.expireDate {
            accessToken = nil
            let refreshOperation = refreshTokenOperation()
            fetchDataOperation.addDependency(refreshOperation)
            operationQueue.addOperation(refreshOperation)
        }
        operationQueue.addOperation(fetchDataOperation)
    }
}
