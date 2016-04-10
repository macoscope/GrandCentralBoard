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
    case RequestTemplateFinalizationError
    case SerializationError(error: ErrorType?)
    case NetworkError(error: ErrorType?)
}


class RequestSender {

    func sendRequestForRequestTemplate<T: RequestTemplateProtocol>(requestTemplate: T, completionBlock: ((ResultType<T.ResultType, RequestSenderError>.result) -> Void)?) -> Void {
        let requestBuilder = RequestBuilder<T>(requestTemplate: requestTemplate)

        do {
            let URLRequest = try requestBuilder.buildURLRequest()

            Alamofire.request(URLRequest).responseData(completionHandler: { response in
                switch response.result {
                case .Success(let data):
                    var result: AnyObject?
                    do {
                        result = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.init(rawValue: 0))
                    } catch {
                        result = response.result.value
                    }
                    
                    if let unwrapperResult = result {
                        do {
                            let processedResult = try requestTemplate.finalizeWithResponse(response.response!, result: unwrapperResult)
                            completionBlock?(.Success(processedResult))
                        } catch {
                            completionBlock?(.Failure(RequestSenderError.RequestTemplateFinalizationError))
                        }
                    } else {
                        completionBlock?(.Failure(RequestSenderError.SerializationError(error: response.result.error)))
                    }

                case .Failure(let error):
                    completionBlock?(.Failure(RequestSenderError.NetworkError(error: error)))
                }
            })

        } catch let error {
            if let description = (error as? CustomStringConvertible)?.description {
                completionBlock?(.Failure(.URLRequestBuildingError(description: description)))
            } else {
                completionBlock?(.Failure(.URLRequestBuildingError(description: "")))
            }
        }

    }

}
