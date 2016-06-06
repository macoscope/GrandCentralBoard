//
//  GoogleTokenResponseModel.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 06.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Decodable

public struct AccessToken: Decodable {

    public let token: String
    public let expireDate: NSDate

    public init(token: String, expiresIn: Int) {
        self.token = token
        self.expireDate = NSDate(timeIntervalSinceNow: NSTimeInterval(expiresIn))
    }

    public static func decode(json: AnyObject) throws -> AccessToken {
        return try AccessToken(token: json => "access_token", expiresIn: json => "expires_in")
    }

    public func isExpired() -> Bool {
        return NSDate() >= expireDate
    }
}
