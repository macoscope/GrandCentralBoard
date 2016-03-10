//
//  Created by Oktawian Chojnacki on 09.03.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import XCTest

@testable import GrandCentralBoard

class ConfigurationTests: XCTestCase {

    func testCorrectConfigurationLoads() {

        if let path = NSBundle(forClass: ConfigurationTests.self).pathForResource("configurationCorrect", ofType: "json") {
            if let jsonData = NSData(contentsOfFile: path) {
                do {
                    let configuration = try Configuration.configurationFromData(jsonData)
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
                    let _ = try Configuration.configurationFromData(jsonData)
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
                    let _ = try Configuration.configurationFromData(jsonData)
                    XCTFail()
                } catch let error as NSError {
                    XCTAssertEqual(error.domain, NSCocoaErrorDomain)
                }
            }
        }
    }

}
