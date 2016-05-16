//
//  String.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 11.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import Foundation
import MD5

extension String {
    func containsAnyString(strings: [String]) -> Bool {
        for string in strings where containsString(string) {
            return true
        }
        return false
    }

    func stringByRemovingOccurrencesOfStrings(strings: [String]) -> String {
        var result: String = self
        for string in strings {
            result = result.stringByReplacingOccurrencesOfString(string, withString: "")
        }
        return result
    }

    func trim() -> String {
        return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}

extension String {
    func md5Hash() -> String? {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)
        return data?.md5Hash()
    }
}
