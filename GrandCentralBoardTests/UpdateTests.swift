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

class UpdateTests: XCTestCase {
    
    func testJSONMappingWithRequiredFields() {
        let jsonURL = NSBundle(forClass: self.dynamicType).URLForResource("UpdatesTests", withExtension: "json")
        let json = NSData(contentsOfURL: jsonURL!)
        
        let updates = try! Update.updatesFromData(json!)
        expect(updates.count) == 2
        
        let firstUpdate = updates[0]
        expect(firstUpdate.bonus) == 10
        expect(firstUpdate.name) == "aaa"
        expect(firstUpdate.date) == NSDate(timeIntervalSince1970: 1457710841)
        expect(firstUpdate.childBonuses.count) == 0
        
        
        let secondUpdate = updates[1]
        expect(secondUpdate.bonus) == 50
        expect(secondUpdate.name) == "bbb"
        expect(secondUpdate.date) == NSDate(timeIntervalSince1970: 1457710241)
        expect(secondUpdate.childBonuses.count) == 1
        expect(secondUpdate.childBonuses[0].bonus) == 20
        expect(secondUpdate.childBonuses[0].name) == "bbb"
        expect(secondUpdate.childBonuses[0].date) == NSDate(timeIntervalSince1970: 1457711441)
    }
    
}
