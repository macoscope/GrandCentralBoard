//
//  RequestBuilder.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 06/04/16.
//

import Foundation


enum RequestBuilderError : ErrorType {
    case IncorrectBaseURL(URL: NSURL)
    case IncorrectResultURL(baseURL: NSURL, path: String)
}


class RequestBuilder<T: RequestTemplateProtocol> {

    let requestTemplate: T
    
    init(requestTemplate: T) {
        self.requestTemplate = requestTemplate
    }

    func buildURLRequest() throws -> NSURLRequest {
        let URL = try createURL()

        let URLRequest = NSMutableURLRequest.init(URL: URL)
        URLRequest.HTTPBody = try createHTTPBody()
        URLRequest.HTTPMethod = self.requestTemplate.method.HTTPMethod
        URLRequest .setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        return URLRequest
    }

    private func createHTTPBody() throws -> NSData? {
        switch requestTemplate.method {
        case .Get(_):
            return nil
        case .Post(let bodyParameters, _):
            return try NSJSONSerialization.dataWithJSONObject(bodyParameters, options: NSJSONWritingOptions.init(rawValue: 0))
        }
    }

    private func createURL() throws -> NSURL {
        guard let URLComponents = NSURLComponents.init(URL: self.requestTemplate.baseURL, resolvingAgainstBaseURL: true) else {
            throw RequestBuilderError.IncorrectBaseURL(URL: self.requestTemplate.baseURL)
        }

        URLComponents.path = URLComponents.path?.stringByAppendingString(self.requestTemplate.path)
        URLComponents.queryItems = queryParametersAsQueryItems()

        if let URL = URLComponents.URL {
            return URL
        } else {
            throw RequestBuilderError.IncorrectResultURL(baseURL: self.requestTemplate.baseURL, path: self.requestTemplate.path)
        }
    }

    private func queryParametersAsQueryItems() -> Array<NSURLQueryItem> {
        return self.requestTemplate.method.queryParameters.map { (key, value) -> NSURLQueryItem in
            return NSURLQueryItem.init(name: key, value: value)
        }
    }

}
