//
//  Alamofire+NetworkRequestManager.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 07.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Alamofire

extension Manager : NetworkRequestManager {

    func requestJSON(method: Method, url: NSURL, parameters: [String : AnyObject]?, headers: [String : String]?, completion: (ResultType<AnyObject, NSError>.result) -> Void) {
        let method = Alamofire.Method(fromMethod: method)
        self.request(method, url, parameters: parameters, encoding: .JSON, headers: headers).responseJSON { response in
            switch response.result {
            case .Failure(let error):
                completion(.Failure(error))
            case .Success(let value):
                completion(.Success(value))
            }
        }
    }
}

extension Alamofire.Method {
    init(fromMethod method: Method) {
        switch method {
        case .CONNECT: self = .CONNECT
        case .DELETE: self = .DELETE
        case .GET: self = .GET
        case .HEAD: self = .HEAD
        case .OPTIONS: self = .OPTIONS
        case .PATCH: self = .PATCH
        case .POST: self = .POST
        case .PUT: self = .PUT
        case .TRACE: self = .TRACE
        }
    }
}