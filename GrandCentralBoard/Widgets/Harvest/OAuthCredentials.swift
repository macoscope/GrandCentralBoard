//
//  OAuthCredentials.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-11.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation


struct OAuthCredentials {
    let accessToken: String
    let refreshToken: String
    let expirationTime: NSTimeInterval

    var isTokenExpired: Bool {
        return NSDate().timeIntervalSince1970 > expirationTime
    }
}
