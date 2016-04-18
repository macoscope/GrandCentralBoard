//
//  BillingUserList.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-18.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Decodable


typealias BillingUserID = Int


struct BillingUserList {
    let userIDs: [BillingUserID]
}

extension BillingUserList : Decodable {
    static func decode(json: AnyObject) throws -> BillingUserList {
        let users = try [BillingUser].decode(json)
        let userIDs = users.map { $0.id }

        return BillingUserList(userIDs: userIDs)
    }

    private struct BillingUser : Decodable {
        let id: BillingUserID

        static func decode(json: AnyObject) throws -> BillingUser {
            let id: BillingUserID = try json => "user" => "id"

            return BillingUser(id: id)
        }
    }
}
