//
//  WebsiteAnalyticsWidgetSnapshotTests.swift
//  GrandCentralBoard
//
//  Created by Maciek Grzybowski on 20.05.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import FBSnapshotTestCase
import GCBCore
@testable import GrandCentralBoard


private final class TestAnalyticsDataProvider: AnalyticsDataProviding {

    private let result: Result<AnalyticsReport>

    init(result: Result<AnalyticsReport>) {
        self.result = result
    }

    func pageViewsReportFromDate(startDate: NSDate, toDate endDate: NSDate,
                                 completion: (Result<AnalyticsReport>) -> Void) {
        completion(result)
    }
}

final class WebsiteAnalyticsWidgetSnapshotTests: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
//        recordMode = true
    }

    func testWidgetShowsErrorWhenError() {
        let errorProvider = TestAnalyticsDataProvider(result: .Failure(NSError(domain: "", code: 0, userInfo: nil)))
        let pageViewsSource = PageViewsSource(dataProvider: errorProvider, daysInReport: 0, refreshInterval: 0, validPathPrefix: nil)

        let widget = WebsiteAnalyticsWidget(sources: [])
        widget.update(pageViewsSource)

        FBSnapshotVerifyView(widget.view)
    }

    func testWidgetShowsErrorWhenNoData() {
        let emptyDataSet = AnalyticsReport(rows: [])
        let errorProvider = TestAnalyticsDataProvider(result: .Success(emptyDataSet))
        let pageViewsSource = PageViewsSource(dataProvider: errorProvider, daysInReport: 0, refreshInterval: 0, validPathPrefix: nil)

        let widget = WebsiteAnalyticsWidget(sources: [])
        widget.update(pageViewsSource)

        FBSnapshotVerifyView(widget.view)
    }

    func testWidgetShowsData() {
        let dataSet = AnalyticsReport(rows: [
                AnalyticsReportRow(dimensions: ["/url/", "Title A"], values: ["33"]),
                AnalyticsReportRow(dimensions: ["/url/", "Title B"], values: ["32"]),
                AnalyticsReportRow(dimensions: ["/url/", "Title C"], values: ["31"]),
                AnalyticsReportRow(dimensions: ["/url/", "Title D"], values: ["30"]),
            ])
        let errorProvider = TestAnalyticsDataProvider(result: .Success(dataSet))
        let pageViewsSource = PageViewsSource(dataProvider: errorProvider, daysInReport: 0, refreshInterval: 0, validPathPrefix: nil)

        let widget = WebsiteAnalyticsWidget(sources: [])
        widget.update(pageViewsSource)

        FBSnapshotVerifyView(widget.view)
    }
}
