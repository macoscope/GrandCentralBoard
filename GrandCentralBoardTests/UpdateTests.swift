//
//  UpdateTests.swift
//  GrandCentralBoard
//
//  Created by Bartłomiej Chlebek on 06/04/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import XCTest
import Nimble
@testable import GrandCentralBoard

private let ISO8601DateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    return formatter
}()

private extension NSDate {
    convenience init?(ISO8601String: String) {
        guard let date = ISO8601DateFormatter.dateFromString(ISO8601String) else { return nil }
        self.init(timeIntervalSince1970: date.timeIntervalSince1970)
    }
}

class UpdateTests: XCTestCase {
    
    func testJSONMappingWithRequiredFields() {
        let jsonURL = NSBundle(forClass: self.dynamicType).URLForResource("UpdatesTests", withExtension: "json")
        let json = NSData(contentsOfURL: jsonURL!)
        
        let updates = try! Update.updatesFromData(json!)
        expect(updates.count) == 2
        
        let firstUpdate = updates[0]
        expect(firstUpdate.bonus) == 10
        expect(firstUpdate.name) == "aaa"
        expect(firstUpdate.date) == NSDate(ISO8601String: "2016-03-11T15:40:41Z")!
        expect(firstUpdate.childBonuses.count) == 0
        
        
        let secondUpdate = updates[1]
        expect(secondUpdate.bonus) == 50
        expect(secondUpdate.name) == "bbb"
        expect(secondUpdate.date) == NSDate(ISO8601String: "2016-03-11T15:30:41Z")!
        expect(secondUpdate.childBonuses.count) == 1
        expect(secondUpdate.childBonuses[0].bonus) == 20
        expect(secondUpdate.childBonuses[0].name) == "bbb"
        expect(secondUpdate.childBonuses[0].date) == NSDate(ISO8601String: "2016-03-11T15:50:41Z")!
    }
    
}
