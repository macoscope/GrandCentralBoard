//
//  Range.swift
//  GrandCentralBoard
//
//  Created by krris on 25/02/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation

extension Range {
    
    func randomElement() -> Generator.Element? {
        let indexes = count as! Int
        let randomIndex = Int(arc4random_uniform(UInt32(indexes)))
        let jumpDistance = randomIndex as! Generator.Element.Distance
        return first?.advancedBy(jumpDistance)
    }
    
}