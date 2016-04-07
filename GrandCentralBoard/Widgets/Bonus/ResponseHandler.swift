//
//  ResponseHandler.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 06/04/16.
//

import Foundation


enum ResponseHandler {
    case Success(response: NSURLResponse, result: NSData)
    case Failure(error: NSError?)
}