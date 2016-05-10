//
//  Created by Oktawian Chojnacki on 22.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import XCTest
import GrandCentralBoardCore
@testable import GrandCentralBoard

final class ConfigurableMock: Configurable {
    let expectation: XCTestExpectation
    var expectationAlreadyFulfilled = false

    init(expectation: XCTestExpectation) {
        self.expectation = expectation
    }

    func configure(configuration: Configuration) throws {
        // We need this because on Travis we can't depend on timer firing exactly as often as it should.
        guard !expectationAlreadyFulfilled else { return }

        expectation.fulfill()
        expectationAlreadyFulfilled = true
    }
}

public final class ConfigurationDownloaderMock: ConfigurationFetching {
    public func fetchConfiguration(closure: (Result<Configuration>) -> ()) {
        closure(.Success(Configuration(builders: [], settings: [])))
    }
}

class ConfigurationRefresherTests: XCTestCase {

    var configuree: Configurable?
    var refresher: ConfigurationRefresher?
    var configurationFetching: ConfigurationFetching?

    func testConfigureIsCalledAfterRefresherInitialization() {
        let expectation = expectationWithDescription("configure called on ConfigurationFetching")
        configuree = ConfigurableMock(expectation: expectation)

        configurationFetching = ConfigurationDownloaderMock()

        refresher = ConfigurationRefresher(interval: 1, configuree: configuree!, fetcher: configurationFetching!)
        refresher?.start()

        waitForExpectationsWithTimeout(2) { error in
            XCTAssert(error == nil)
        }
    }
}
