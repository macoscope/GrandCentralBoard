//
//  NetworkRequestManager.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 07.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation

protocol NetworkRequestManager {
    func requestJSON(request: NSURLRequest, completion: (ResultType<AnyObject, NSError>.result) -> Void)
}
