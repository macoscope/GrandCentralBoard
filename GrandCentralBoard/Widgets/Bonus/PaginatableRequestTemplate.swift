//
//  PaginatableRequestTemplate.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 07/04/16.
//

import Foundation
import Result


class PaginatableRequestTemplate<T: RequestTemplateProtocol> : RequestTemplateProtocol {

    let requestTemplate: T
    let skip: Int
    let take: Int

    init(requestTemplate: T, skip: Int, take: Int) {
        self.requestTemplate = requestTemplate
        self.skip = skip
        self.take = take
    }

    var baseURL: NSURL {
        get {
            return requestTemplate.baseURL
        }
    }

    var path: String {
        get {
            return requestTemplate.path
        }
    }

    var method: MethodType {
        get {
            var method = requestTemplate.method
            method.addQueryParameter("skip", value: String(skip))
            method.addQueryParameter("take", value: String(take))
            return method
        }
    }

    func finalizeWithResponse(responseHandler: ResponseHandler) -> Result<T.ResultType, NSError> {
        return self.requestTemplate.finalizeWithResponse(responseHandler)
    }


}