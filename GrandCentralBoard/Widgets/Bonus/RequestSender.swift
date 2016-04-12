//
//  RequestSender.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 07/04/16.
//

import Foundation
import Alamofire
import GrandCentralBoardCore


enum RequestSenderError : ErrorType {
    case URLRequestBuildingError(description: String)
    case RequestTemplateFinalizationError
    case SerializationError
    case NetworkError(error: ErrorType?)
}


final class RequestSender {

    private let configuration: RequestSenderConfiguration

    init(configuration: RequestSenderConfiguration) {
        self.configuration = configuration
    }

    func sendRequestForRequestTemplate<T: RequestTemplateProtocol>(requestTemplate: T, completionBlock: ((GrandCentralBoardCore.Result<T.ResultType>) -> Void)?) -> Void {
        let wrappingRequestTemplate = WrappingRequestTemplate(requestTemplate: requestTemplate, queryParameters: self.configuration.queryParameters)
        let requestBuilder = RequestBuilder<WrappingRequestTemplate<T>>(requestTemplate: wrappingRequestTemplate)

        do {
            let URLRequest = try requestBuilder.buildURLRequest()

            Alamofire.request(URLRequest).responseData(completionHandler: { response in
                switch response.result {
                case .Success(let data):
                    guard let URLResponse = response.response else {
                        completionBlock?(.Failure(RequestSenderError.NetworkError(error: nil)))
                        return
                    }
                    var result: AnyObject?
                    do {
                        result = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.init(rawValue: 0))
                    } catch {
                        result = data
                    }
                    
                    if let unwrapperResult = result {
                        do {
                            let processedResult = try requestTemplate.finalizeWithResponse(URLResponse, result: unwrapperResult)
                            completionBlock?(.Success(processedResult))
                        } catch let error {
                            completionBlock?(.Failure(error))
                        }
                    } else {
                        completionBlock?(.Failure(RequestSenderError.SerializationError))
                    }

                case .Failure(let error):
                    completionBlock?(.Failure(error))
                }
            })

        } catch let error {
            if let description = (error as? CustomStringConvertible)?.description {
                completionBlock?(.Failure(RequestSenderError.URLRequestBuildingError(description: description)))
            } else {
                completionBlock?(.Failure(RequestSenderError.URLRequestBuildingError(description: "")))
            }
        }

    }

}
