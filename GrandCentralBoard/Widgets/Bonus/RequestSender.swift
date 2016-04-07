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
    case SerializationError(error: ErrorType)
    case NetworkError(error: ErrorType?)
}


class RequestSender {

    func sendRequestForRequestTemplate<T: RequestTemplateProtocol>(requestTemplate: T, completionBlock: ((ResultType<T.ResultType, RequestSenderError>.result) -> Void)?) -> Void {
        let requestBuilder = RequestBuilder<T>(requestTemplate: requestTemplate)

        do {
            let URLRequest = try requestBuilder.buildURLRequest()
            Alamofire.request(URLRequest).response(completionHandler: { (request, response, data, error) in
                if let response = response where response.statusCode == 200 {
                    let data = data ?? NSData.init()

                    do {
                        let JSONObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                        let result = try requestTemplate.finalizeWithResponse(response, result: JSONObject)
                        completionBlock?(.Success(result))
                    } catch RequestTemplateErrors.FinalizeError {
                        completionBlock?(.Failure(.RequestTemplateFinalizationError))
                    } catch let error {
                        completionBlock?(.Failure(.SerializationError(error: error)))
                    }

                } else {
                    completionBlock?(.Failure(.NetworkError(error: error)))
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
