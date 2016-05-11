//
//  Alamofire+NetworkRequestManager.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 07.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Alamofire
import GCBCore

extension Manager : NetworkRequestManager {

    func requestJSON(method: Method, url: NSURL, parameters: [String : AnyObject]?,
                     headers: [String : String]?, encoding: ParameterEncoding, completion: (GCBCore.Result<AnyObject>) -> Void) {
        let method = Alamofire.Method(fromMethod: method)
        let encoding = Alamofire.ParameterEncoding(fromEncoding: encoding)
        self.request(method, url, parameters: parameters, encoding: encoding, headers: headers).responseJSON { response in
            switch response.result {
            case .Failure(let error):
                completion(.Failure(error))
            case .Success(let value):
                completion(.Success(value))
            }
        }
    }}

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

extension Alamofire.ParameterEncoding {
    init(fromEncoding encoding: ParameterEncoding) {
        switch encoding {
        case .URL:
            self = .URL
        case .URLEncodedInURL:
            self = .URLEncodedInURL
        case .JSON:
            self = .JSON
        case .PropertyList(let format, let writeOptions):
            self = .PropertyList(format, writeOptions)
        }
    }
}
