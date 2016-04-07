//
//  RequestTemplate.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 06/04/16.
//


import Foundation
import Result


public enum MethodType {
    case Get(getParameters: Dictionary<String, String>)
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

    var HTTPMethod: String {
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
            self = MethodType.Get(getParameters: queryParameters)
        case .Post(var queryParameters, let bodyParameters):
            queryParameters[key] = value
            self = MethodType.Post(bodyParameters: bodyParameters, queryParameters: queryParameters)
        }
    }
}


protocol RequestTemplateProtocol {
    associatedtype ResultType

    var method: MethodType { get }
    var path: String { get }
    var baseURL: NSURL { get }

    func finalizeWithResponse(responseHandler: ResponseHandler) -> Result<ResultType, NSError>
}


class RequestTemplate<ResultType>: RequestTemplateProtocol {

    let path: String
    let method: MethodType
    let baseURL: NSURL

    init(baseURL: NSURL, path: String, method: MethodType) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
    }

    func finalizeWithResponse(responseHandler: ResponseHandler) -> Result<ResultType, NSError> {
        return Result.Failure(NSError.init(domain: "test", code: 123, userInfo: [:]))
    }
}
