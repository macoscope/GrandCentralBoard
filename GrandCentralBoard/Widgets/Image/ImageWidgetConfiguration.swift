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
    let header: ImageWidgetHeaderConfiguration?
}

struct ImageWidgetHeaderConfiguration {
    let title: String
    let subtitle: String?
}

extension ImageWidgetConfiguration: Decodable {
    static func decode(json: AnyObject) throws -> ImageWidgetConfiguration {
        return try ImageWidgetConfiguration(
            imagePaths: json => "urls",
            header: json =>? "header"
        )
    }
}

extension ImageWidgetHeaderConfiguration: Decodable {
    static func decode(json: AnyObject) throws -> ImageWidgetHeaderConfiguration {
        return try ImageWidgetHeaderConfiguration(
            title: json => "title",
            subtitle: json =>? "subtitle"
        )
    }
}
