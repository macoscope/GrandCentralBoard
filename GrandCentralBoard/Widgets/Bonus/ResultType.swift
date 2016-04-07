//
//  ResultType.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 07/04/16.
//

import Foundation
import Result


struct ResultType<T, ErrorType: Swift.ErrorType> {
    typealias result = Result<T, ErrorType>
}
