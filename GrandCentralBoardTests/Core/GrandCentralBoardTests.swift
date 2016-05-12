//
//  Created by Oktawian Chojnacki on 31.12.2015.
//  Copyright © 2015 Oktawian Chojnacki. All rights reserved.
//

import XCTest
import Decodable
import GCBCore
@testable import GrandCentralBoard


class GrandCentralBoardTests: XCTestCase {

    let scheduler = Scheduler()
    let stack = AutoStack()
    let settings = WidgetSettings(name: "watch", settings: ["timeZone": "Europe/Warsaw", "calendar": ""])
    let watchWidgetBuilder = WatchWidgetBuilder(dataDownloader: DataDownloader())

    func testThrowsWhenWidgetsCountExpectationIsNotMet() {

        let config = Configuration(builders: [watchWidgetBuilder], settings: [settings])

        do {
            let board = GrandCentralBoardController(scheduler: scheduler, stack: stack)
            try board.configure(config)
        } catch let error as GrandCentralBoardError {
            XCTAssertTrue(error == GrandCentralBoardError.WrongWidgetsCount)
            return
        } catch {
            XCTFail()
        }

        XCTFail()
    }

    func testThrowsWhenWidgetsCountExpectationIsNotMetWithZero() {

        let config = Configuration(builders: [], settings: [settings])

        do {
            let board = GrandCentralBoardController(scheduler: scheduler, stack: stack)
            try board.configure(config)
        } catch let error as GrandCentralBoardError {
            XCTAssertTrue(error == GrandCentralBoardError.WrongWidgetsCount)
            return
        } catch {
            XCTFail()
        }

        XCTFail()
    }

    func testThrowsWhenWidgetsConfigurationIsMissingKeyCalendar() {

        let wrongSettings = WidgetSettings(name: "watch", settings: ["timeZone": "Europe/Warsaw"])

        let config = Configuration(builders: [watchWidgetBuilder],
                                   settings: [wrongSettings, wrongSettings, wrongSettings, wrongSettings, wrongSettings, wrongSettings])

        do {
            let board = GrandCentralBoardController(scheduler: scheduler, stack: stack)
            try board.configure(config)
        } catch let error as MissingKeyError {
            XCTAssertTrue(error.key == "calendar")

            return
        } catch {
            XCTFail()
        }

        XCTFail()
    }

    func testNotThrowsWhenWidgetsConfigurationIsCorrect() {

        let config = Configuration(builders: [watchWidgetBuilder], settings: [settings, settings, settings, settings, settings, settings])

        do {
            let board = GrandCentralBoardController(scheduler: scheduler, stack: stack)
            try board.configure(config)
        } catch {
            XCTFail()
        }
    }

    func testStackedSixViewsWhenWidgetsConfigurationIsCorrect() {

        final class StackingMock: ViewStacking {

            var stackedViews = [UIView]()

            func stackView(view: UIView) {
                stackedViews.append(view)
            }

            func removeAllStackedViews() {
                stackedViews = []
            }
        }

        let config = Configuration(builders: [watchWidgetBuilder], settings: [settings, settings, settings, settings, settings, settings])

        let stackingMock = StackingMock()

        let board = GrandCentralBoardController(scheduler: scheduler, stack: stackingMock)
        try! board.configure(config)

        XCTAssertEqual(stackingMock.stackedViews.count, 6)
    }

    func testScheduledEighteenJobsWhenWidgetsConfigurationIsCorrect() {

        final class SchedulingMock: SchedulingJobs {

            var jobs = [Schedulable]()

            private func schedule(job: Schedulable) {
                jobs.append(job)
            }

            func invalidateAll() {
                jobs = []
            }
        }
        let schedulingMock = SchedulingMock()
        let config = Configuration(builders: [watchWidgetBuilder], settings: [settings, settings, settings, settings, settings, settings])

        let board = GrandCentralBoardController(scheduler: schedulingMock, stack: stack)
        try! board.configure(config)

        XCTAssertEqual(schedulingMock.jobs.count, 18)
    }

}
