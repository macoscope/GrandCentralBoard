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
    func sortByDate() -> [Bonus] {
        return self.sort({ $0.date.compare($1.date) == .OrderedDescending })
    }

    func flatten() -> [Bonus] {
        let mappedBonuses = self.map { bonus in
            return [ Bonus(name: bonus.name, amount: bonus.amount, receiver: bonus.receiver, date: bonus.date, childBonuses: [])]
                + bonus.childBonuses
        }
        return mappedBonuses.flatMap { $0 }
    }
}
