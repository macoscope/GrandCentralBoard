//
//  RequestTemplate.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 06/04/16.
//


import Foundation
import GrandCentralBoardCore


enum MethodType {
    case Get(queryParameters: Dictionary<String, String>)
    case Post(bodyParameters: Dictionary<String, String>, queryParameters: Dictionary<String, String>)

    var queryParameters: Dictionary<String, String> {
        get {
            switch self {
            case .Get(let queryParameters):
                return queryParameters
            case .Post(_, let queryParameters):
                return queryParameters
            }
        }
    }

    var httpMethod: String {
        get {
            switch self {
            case .Get(_):
                return "GET"
            case .Post(_, _):
                return "POST"
            }
        }
    }

    mutating func addQueryParameter(key: String, value: String) {
        switch self {
        case .Get(var queryParameters):
            queryParameters[key] = value
            self = MethodType.Get(queryParameters: queryParameters)
        case .Post(var queryParameters, let bodyParameters):
            queryParameters[key] = value
            self = MethodType.Post(bodyParameters: bodyParameters, queryParameters: queryParameters)
        }
    }
}

enum ResponseResultType {
    case JSON
    case Data
}


enum RequestTemplateError: ErrorType {
    case FinalizeError
}


protocol RequestTemplateProtocol {
    associatedtype ResultType

    var method: MethodType { get }
    var path: String { get }
    var baseURL: NSURL { get }
    var responseResultType: ResponseResultType { get }

    func finalizeWithResponse(response: NSURLResponse, result: AnyObject) throws -> ResultType
}

class RequestTemplate<ResultType>: RequestTemplateProtocol {

    let path: String
    let method: MethodType
    let baseURL: NSURL
    let responseResultType: ResponseResultType

    init(baseURL: NSURL, path: String, method: MethodType, responseResultType: ResponseResultType) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.responseResultType = responseResultType
    }

    func finalizeWithResponse(response: NSURLResponse, result: AnyObject) throws -> ResultType {
        return result as! ResultType
    }
}
