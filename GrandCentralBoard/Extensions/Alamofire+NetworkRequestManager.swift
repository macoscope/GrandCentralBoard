//
//  Alamofire+NetworkRequestManager.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 07.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Alamofire

extension Manager : NetworkRequestManager {

    func requestJSON(request: NSURLRequest, completion: (ResultType<AnyObject, NSError>.result) -> Void) {
        self.request(request).responseJSON { response in
                switch response.result {
                case .Failure(let error):
                    completion(.Failure(error))
                case .Success(let value):
                    completion(.Success(value))
                }
        }
    }
}
