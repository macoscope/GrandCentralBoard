//
//  Created by Oktawian Chojnacki on 07.03.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import XCTest
@testable import GrandCentralBoard

final class SourceMock : UpdatingSource {
    var interval: NSTimeInterval = 0
}

let source = SourceMock()

final class TargetMock : Updateable {
    var sources: [UpdatingSource] = [source]
    let expectation: XCTestExpectation

    func update(source: UpdatingSource) {
        expectation.fulfill()
    }

    init(expectation: XCTestExpectation) {
        self.expectation = expectation
    }
}

class SchedulerTests: XCTestCase {

    func testSchedulerFiresTheSelectorOnTarget() {

        let scheduler = Scheduler()

        let expectation = expectationWithDescription("Called selector")

        let target: Updateable = TargetMock(expectation: expectation)

        let job = Job(target: target, source: source)

        scheduler.schedule(job)

        waitForExpectationsWithTimeout(2) { error in
            XCTAssertNil(error)
        }
    }

}
