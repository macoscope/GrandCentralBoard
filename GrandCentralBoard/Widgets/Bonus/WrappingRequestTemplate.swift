//
//  WrappingRequestTemplate.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 10/04/16.
//

import Foundation


class WrappingRequestTemplate<T: RequestTemplateProtocol> : RequestTemplateProtocol {

    typealias parameters = [String: String]

    private let queryParameters: parameters
    private let requestTemplate: T

    init(requestTemplate: T, queryParameters: parameters) {
        self.queryParameters = queryParameters
        self.requestTemplate = requestTemplate
    }

    var method: MethodType {
        get {
            var method = self.requestTemplate.method
            for (key, value) in queryParameters {
                method.addQueryParameter(key, value: value)
            }
            return method
        }
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

    func finalizeWithResponse(response: NSURLResponse, result: AnyObject) throws -> T.ResultType {
        return try requestTemplate.finalizeWithResponse(response, result: response)
    }

}
