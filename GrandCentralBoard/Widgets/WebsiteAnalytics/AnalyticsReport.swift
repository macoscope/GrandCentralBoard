//
//  AnalyticsReport.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 13.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Decodable

struct ReportRow {
    let dimensions: [String]
    let values: [String]
}

struct Report  {
    let rows: [ReportRow]
}

extension ReportRow : Decodable {
    static func decode(json: AnyObject) throws -> ReportRow {
        var values: [String] = []
        if let metrics = (try (json => "metrics") as? [AnyObject])?.first {
            values = try metrics => "values"
        }
        return try ReportRow(dimensions: json => "dimensions", values: values)
    }
}

extension Report : Decodable {
    static func decode(json: AnyObject) throws -> Report {
        let reportsArray = try (json => "reports") as? [AnyObject]
        if let report = reportsArray?.first {
            return try Report(rows: report => "data" => "rows")
        } else {
            return Report(rows: [])
        }
    }
}
