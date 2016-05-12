//
//  RequestSenderConfiguration.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 10/04/16.
//

import Foundation


final class RequestSenderConfiguration {

    typealias parameters = [String: String]

    let queryParameters: parameters

    init(queryParameters: parameters) {
        self.queryParameters = queryParameters
    }

}
