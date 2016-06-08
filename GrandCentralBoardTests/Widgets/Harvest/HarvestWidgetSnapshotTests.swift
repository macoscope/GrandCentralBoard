//
//  HarvestWidgetSnapshotTests.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 20.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import FBSnapshotTestCase
import GCBCore
import GCBUtilities
@testable import GrandCentralBoard


private final class TestHarvestProvider: HarvestAPIProviding {

    let shouldFailRequest: Bool

    init(shouldFailRequest: Bool) {
        self.shouldFailRequest = shouldFailRequest
    }

    private func refreshTokenIfNeeded(completion: (Result<AccessToken>) -> Void) {
        completion(.Success(AccessToken(token: "test_token", expiresIn: 3600)))
    }

    private func fetchBillingStatsForDates(dates: [NSDate], completion: (Result<[DailyBillingStats]>) -> Void) {
        if shouldFailRequest {
            completion(.Failure(TestError()))
        } else {
            completion(.Success([]))
        }
    }
}

final class HarvestWidgetSnapshotTests: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
//        recordMode = true
    }

    func testViewWithFailure() {
        let api = TestHarvestProvider(shouldFailRequest: true)
        let harvestSource = HarvestSource(apiProvider: api, refreshInterval: 60, numberOfPreviousDays: 5, includeWeekends: true)
        let widget = HarvestWidget(source: harvestSource, numberOfDays: 5)
        widget.update(harvestSource)

        let widgetView = widget.view
        widgetView.frame = CGRect(x: 0, y: 0, width: 640, height: 540)

        FBSnapshotVerifyView(widget.view)
    }

    func testViewWithNoStats() {
        let api = TestHarvestProvider(shouldFailRequest: false)
        let harvestSource = HarvestSource(apiProvider: api, refreshInterval: 60, numberOfPreviousDays: 5, includeWeekends: true)
        let widget = HarvestWidget(source: harvestSource, numberOfDays: 5)
        widget.update(harvestSource)

        let widgetView = widget.view
        widgetView.frame = CGRect(x: 0, y: 0, width: 640, height: 540)

        FBSnapshotVerifyView(widget.view)
    }
}
