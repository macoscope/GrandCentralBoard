//
//  ImageWidgetConfiguration.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 14.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Decodable

struct ImageWidgetConfiguration {
    let imagePaths: [String]
    let isHeaderVisible: Bool?
}

extension ImageWidgetConfiguration: Decodable {
    static func decode(json: AnyObject) throws -> ImageWidgetConfiguration {
        return try ImageWidgetConfiguration(
            imagePaths: json => "urls",
            isHeaderVisible: json =>? "isHeaderVisible"
        )
    }
}
