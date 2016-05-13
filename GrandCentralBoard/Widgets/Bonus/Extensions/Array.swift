//
//  Array.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 12/04/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation


extension RangeReplaceableCollectionType where Generator.Element : Equatable {

    mutating func removeObject(object: Generator.Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }

}

extension SequenceType where Generator.Element == Bonus {
    func sortByDate(order: NSComparisonResult) -> [Bonus] {
        return self.sort({ $0.date.compare($1.date) == order })
    }

    func flatten() -> [Bonus] {
        return self.flatMap { return [$0] + $0.childBonuses }
    }
}
