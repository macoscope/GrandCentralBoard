//
//  RequestSender.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 07/04/16.
//

import Foundation
import Alamofire
import GCBCore


enum RequestSenderError: ErrorType {
    case URLRequestBuildingError(description: String)
    case RequestTemplateFinalizationError
    case SerializationError
    case NetworkError(error: ErrorType?)
    case Unknown
}


protocol RequestSending {
    func sendRequestForRequestTemplate<T: RequestTemplateProtocol>(requestTemplate: T,
                                                                   completionBlock: ((GCBCore.Result<T.ResultType>) -> Void)?) -> Void
}


final class RequestSender: RequestSending {

    private let configuration: RequestSenderConfiguration
    private var requestsInProgress: [Request] = []

    convenience init() {
        self.init(configuration: RequestSenderConfiguration(queryParameters: [:]))
    }

    init(configuration: RequestSenderConfiguration) {
        self.configuration = configuration
    }

    deinit {
        for request in requestsInProgress {
            request.cancel()
        }
    }

    func sendRequestForRequestTemplate<T: RequestTemplateProtocol>(requestTemplate: T,
                                       completionBlock: ((GCBCore.Result<T.ResultType>) -> Void)?) -> Void {
        let wrappingRequestTemplate = WrappingRequestTemplate(requestTemplate: requestTemplate, queryParameters: self.configuration.queryParameters)
        let requestBuilder = RequestBuilder<WrappingRequestTemplate<T>>(requestTemplate: wrappingRequestTemplate)

        do {
            let URLRequest = try requestBuilder.buildURLRequest()
            let request = Alamofire.request(URLRequest)
            requestsInProgress.append(request)

            switch requestTemplate.responseResultType {
            case .JSON:
                    request.responseJSON(completionHandler: { response in
                    switch response.result {
                    case .Success(let JSON):
                        do {
                            let processedResult = try requestTemplate.finalizeWithResponse(response.response!, result: JSON)
                            completionBlock?(.Success(processedResult))
                        } catch let error {
                            completionBlock?(.Failure(error))
                        }

                    case .Failure(let error):
                        completionBlock?(.Failure(error))
                    }
                })

            case .Data:
                request.responseData(completionHandler: { response in
                    self.requestsInProgress.removeObject(request)
                    switch response.result {
                    case .Success(let data):
                        do {
                            let processedResult = try requestTemplate.finalizeWithResponse(response.response!, result: data)
                            completionBlock?(.Success(processedResult))
                        } catch let error {
                            completionBlock?(.Failure(error))
                        }

                    case .Failure(let error):
                        completionBlock?(.Failure(error))
                    }
                })
            }

        } catch let error {
            let description = (error as? CustomStringConvertible)?.description ?? ""
            completionBlock?(.Failure(RequestSenderError.URLRequestBuildingError(description: description)))
        }

    }

}


extension Request: Equatable {

}

public func == (lhs: Request, rhs: Request) -> Bool {
    return lhs.request == rhs.request
}
