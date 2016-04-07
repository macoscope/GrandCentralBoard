//
//  RequestSender.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 07/04/16.
//

import Foundation
import Result
import Alamofire


enum RequestSenderError : ErrorType {
    case URLRequestBuildingError(description: String)
    case RequestTemplateFinalizationError(error: NSError)
    case NetworkError
}


class RequestSender<T: RequestTemplateProtocol> {

    func sendRequestForRequestTemplate(requestTemplate: T, completionBlock: ((ResultType<T.ResultType, RequestSenderError>.result) -> Void)?) -> Void {
        let requestBuilder = RequestBuilder<T>(requestTemplate: requestTemplate)

        do {
            let URLRequest = try requestBuilder.buildURLRequest()
            Alamofire.request(URLRequest).response(completionHandler: { (_, response, data, error) in
                if response?.statusCode == 200 {
                    let result = requestTemplate.finalizeWithResponse(.Success(response: response!, result: data ?? NSData.init()))
                    switch result {
                    case .Success(let data):
                        completionBlock?(.Success(data))
                    case .Failure(let error):
                        completionBlock?(.Failure(.RequestTemplateFinalizationError(error: error)))
                    }
                } else {
                    completionBlock?(.Failure(.NetworkError))
                }
            })

        }
            
        catch let error {
            if let description = (error as? CustomStringConvertible)?.description {
                completionBlock?(.Failure(.URLRequestBuildingError(description: description)))
            } else {
                completionBlock?(.Failure(.URLRequestBuildingError(description: "")))
            }
        }

    }

}
