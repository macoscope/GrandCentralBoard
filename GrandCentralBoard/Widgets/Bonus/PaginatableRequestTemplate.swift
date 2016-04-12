//
//  PaginatableRequestTemplate.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 07/04/16.
//

import Foundation


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
            method.addQueryParameter("limit", value: String(take))
            return method
        }
    }

    var responseResultType: ResponseResultType {
        get {
            return requestTemplate.responseResultType
        }
    }

    func finalizeWithResponse(response: NSURLResponse, result: AnyObject) throws -> T.ResultType {
        return try self.requestTemplate.finalizeWithResponse(response, result: result)
    }

}
