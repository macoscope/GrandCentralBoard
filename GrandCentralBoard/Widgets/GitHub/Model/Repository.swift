//
//  Repository.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 27.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Decodable


struct Repository {
    let name: String
    let fullName: String
    let openIssuesCount: Int
}

extension Repository: Decodable {

    static func decode(json: AnyObject) throws -> Repository {
        return try Repository(name: json => "name",
                          fullName: json => "full_name",
                          openIssuesCount: json => "open_issues_count")
    }
}
