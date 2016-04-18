//
//  NSBundle+LoadJSON.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-19.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import XCTest


extension NSBundle {
    func loadJSON(name: String) -> AnyObject {
        do {
            let url = self.URLForResource(name, withExtension: "json")
            let data = NSData(contentsOfURL: url!)

            return try NSJSONSerialization.JSONObjectWithData(data!, options: [])

        } catch {
            XCTFail("Couldn't load " + name + ".json from the application bundle")

            return [:]
        }
    }
}
