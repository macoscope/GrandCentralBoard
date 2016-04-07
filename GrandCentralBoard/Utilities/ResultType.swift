//
//  ResultType.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 07.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Result

//Created because of the bug in Swift: https://github.com/antitypical/Result/issues/77
struct ResultType<T, ErrorType: Swift.ErrorType> {
    typealias result = Result<T, ErrorType>
}
