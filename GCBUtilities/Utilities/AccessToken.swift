//
//  GoogleTokenResponseModel.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 06.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Decodable

struct AccessToken: Decodable {

    let token: String
    let expireDate: NSDate

    init(token: String, expiresIn: Int) {
        self.token = token
        self.expireDate = NSDate(timeIntervalSinceNow: NSTimeInterval(expiresIn))
    }

    static func decode(json: AnyObject) throws -> AccessToken {
        return try AccessToken(token: json => "access_token", expiresIn: json => "expires_in")
    }

    func isExpired() -> Bool {
        return NSDate() >= expireDate
    }
}
