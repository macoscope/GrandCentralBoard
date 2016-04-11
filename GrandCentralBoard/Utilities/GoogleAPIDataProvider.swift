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
    case ModelDecodeError(ErrorType)
    case UnderlyingError(NSError)
}

protocol APIDataProviding {
    func request(method: Method, url: NSURL, parameters: [String: AnyObject]?, completion: ResultType<AnyObject, APIDataError>.result -> Void)
}

final class GoogleAPIDataProvider : APIDataProviding {

    private let tokenProvider: OAuthTokenProviding
    private var accessToken: AccessToken?

    private let networkRequestManager: NetworkRequestManager

    private let operationQueue = OperationQueue()

    init(tokenProvider: OAuthTokenProviding, networkRequestManager: NetworkRequestManager = Manager()) {
        self.tokenProvider = tokenProvider
        self.networkRequestManager = networkRequestManager
    }

    private func refreshTokenOperation() -> Operation {
        let tokenProvider = self.tokenProvider
        let refreshTokenOperation = BlockOperation(block: { [weak self] (continueWithError) in

            tokenProvider.accessTokenFromRefreshToken({ result in
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

    func request(method: Method, url: NSURL, parameters: [String: AnyObject]?, completion: ResultType<AnyObject, APIDataError>.result -> Void) {

        let fetchDataOperation = BlockOperation (block: { [weak self] (continueWithError) in
            guard let strongSelf = self, let accessToken = strongSelf.accessToken?.token else {
                completion(.Failure(.AuthorizationError))
                continueWithError(error: APIDataError.AuthorizationError)
                return
            }

            let headers = ["Authorization" : "Bearer \(accessToken)"]

            strongSelf.networkRequestManager.requestJSON(method, url: url, parameters: parameters, headers: headers) { result in
                    switch result {
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
