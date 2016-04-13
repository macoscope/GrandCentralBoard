//
//  Array.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 12/04/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation


extension RangeReplaceableCollectionType where Generator.Element : Equatable {

    mutating func removeObject(object : Generator.Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
    
}