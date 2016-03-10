//
//  Created by Oktawian Chojnacki on 09.03.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import XCTest
import GrandCentralBoardCore
@testable import GrandCentralBoard


let dataDownloader = DataDownloader()
let availableBuilders: [WidgetBuilding] = [WatchWidgetBuilder(dataDownloader: dataDownloader)]

class ConfigurationTests: XCTestCase {


    func testCorrectConfigurationLoads() {

        if let path = NSBundle(forClass: ConfigurationTests.self).pathForResource("configurationCorrect", ofType: "json") {
            if let jsonData = NSData(contentsOfFile: path) {
                do {
                    let configuration = try Configuration.configurationFromData(jsonData, availableBuilders: availableBuilders)
                    XCTAssertEqual(configuration.settings.count, 6)
                } catch {
                    XCTFail()
                }
            }
        }

    }

    func testBrokenConfigurationThrows() {
        if let path = NSBundle(forClass: ConfigurationTests.self).pathForResource("configurationBroken", ofType: "json") {
            if let jsonData = NSData(contentsOfFile: path) {
                do {
                    try Configuration.configurationFromData(jsonData, availableBuilders: availableBuilders)
                    XCTFail()
                } catch _ as ConfigurationError {
                    // OK :)
                } catch {
                    XCTFail()
                }
            }
        }
    }

    func testBrokenJSONThrows() {
        if let path = NSBundle(forClass: ConfigurationTests.self).pathForResource("configurationBrokenJSON", ofType: "json") {
            if let jsonData = NSData(contentsOfFile: path) {
                do {
                    try Configuration.configurationFromData(jsonData, availableBuilders: availableBuilders)
                    XCTFail()
                } catch let error as NSError {
                    XCTAssertEqual(error.domain, NSCocoaErrorDomain)
                }
            }
        }
    }

}
