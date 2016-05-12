//
//  BillingProjectList.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-18.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Decodable


typealias BillingProjectID = Int


struct BillingProjectList {
    let projectIDs: [BillingProjectID]
}

extension BillingProjectList : Decodable {
    static func decode(json: AnyObject) throws -> BillingProjectList {
        let projects = try [BillingProject].decode(json)
        let projectIDs = projects.map { $0.id }

        return BillingProjectList(projectIDs: projectIDs)
    }

    private struct BillingProject: Decodable {
        let id: BillingProjectID

        static func decode(json: AnyObject) throws -> BillingProject {
            let id: BillingProjectID = try json => "project" => "id"

            return BillingProject(id: id)
        }
    }
}
