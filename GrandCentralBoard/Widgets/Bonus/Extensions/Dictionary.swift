//
//  Dictionary.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 18/04/16.
//

import Foundation

extension Dictionary {

    mutating func merge(dictionary: Dictionary) {
        for (key, value) in dictionary {
            self.updateValue(value, forKey:key)
        }
    }

}
