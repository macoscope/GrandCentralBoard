//
//  Created by Oktawian Chojnacki on 22.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import XCTest
import GrandCentralBoardCore
@testable import GrandCentralBoard

final class ConfigurableMock: Configurable {
    let expectation: XCTestExpectation

    init(expectation: XCTestExpectation) {
        self.expectation = expectation
    }

    func configure(configuration: Configuration) throws {
        expectation.fulfill()
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

        waitForExpectationsWithTimeout(2) { error in
            XCTAssert(error == nil)
        }
    }
}
