//
//  AnalyticsReport.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 13.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Decodable

struct AnalyticsReportRow {
    let dimensions: [String]
    let values: [String]
}

struct AnalyticsReport {
    let rows: [AnalyticsReportRow]
}

extension AnalyticsReportRow : Decodable {
    static func decode(json: AnyObject) throws -> AnalyticsReportRow {
        var values: [String] = []
        if let metrics = (try (json => "metrics") as? [AnyObject])?.first {
            values = try metrics => "values"
        }
        return try AnalyticsReportRow(dimensions: json => "dimensions", values: values)
    }
}

extension AnalyticsReport : Decodable {
    static func decode(json: AnyObject) throws -> AnalyticsReport {
        let reportsArray = try (json => "reports") as? [AnyObject]
        if let report = reportsArray?.first {
            return try AnalyticsReport(rows: report => "data" => "rows")
        } else {
            return AnalyticsReport(rows: [])
        }
    }
}
