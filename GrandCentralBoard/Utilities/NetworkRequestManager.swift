//
//  NetworkRequestManager.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 07.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation

public enum Method: String {
    case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
}

public enum ParameterEncoding {
    case URL, URLEncodedInURL, JSON, PropertyList(NSPropertyListFormat, NSPropertyListWriteOptions)
}

protocol NetworkRequestManager {
    func requestJSON(method: Method, url: NSURL, parameters: [String : AnyObject]?, headers: [String : String]?, encoding: ParameterEncoding, completion: (ResultType<AnyObject, NSError>.result) -> Void)
}
