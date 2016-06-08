//
//  BonusWidgetSnapshotTests.swift
//  GrandCentralBoard
//
//  Created by krris on 23/05/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import FBSnapshotTestCase
import GCBCore
import GCBUtilities
@testable import GrandCentralBoard

private final class PeopleWithBonusesProvider: PeopleWithBonusesProviding {
    let shouldFailRequest: Bool

    init(shouldFailRequest: Bool) {
        self.shouldFailRequest = shouldFailRequest
    }

    private func fetchPeopleWithBonuses(completionBlock: (Result<[Person]>) -> Void) {
        if shouldFailRequest {
            return completionBlock(Result.Failure(TestError()))
        } else {
            let people: [Person] = []
            return completionBlock(Result.Success(people))
        }
    }
}

final class BonusWidgetSnapshotTests: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
//        recordMode = true
    }

    func testViewWithFailure() {
        let peopleWithBonusesProvider = PeopleWithBonusesProvider(shouldFailRequest: true)
        let source = BonusSource(peopleWithBonusesProvider: peopleWithBonusesProvider)
        let widget = BonusWidget(sources: [source], bubbleResizeDuration: 4, numberOfBubbles: 5)
        widget.update(source)

        let widgetView = widget.view
        widgetView.frame = CGRect(x: 0, y: 0, width: 640, height: 540)

        FBSnapshotVerifyView(widget.view)
    }

    func testViewWithSuccess() {
        let peopleWithBonusesProvider = PeopleWithBonusesProvider(shouldFailRequest: false)
        let source = BonusSource(peopleWithBonusesProvider: peopleWithBonusesProvider)
        let widget = BonusWidget(sources: [source], bubbleResizeDuration: 4, numberOfBubbles: 5)
        widget.update(source)

        let widgetView = widget.view
        widgetView.frame = CGRect(x: 0, y: 0, width: 640, height: 540)

        FBSnapshotVerifyView(widget.view)
    }

}
