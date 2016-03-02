//
//  Created by Krzysztof Werys on 25/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import Foundation

final class BonusSource : Synchronous {
    
    typealias ResultType = Result<[Person]>

    let sourceType: SourceType = .Momentary
    let interval: NSTimeInterval = 5
    
    private var people: [Person] = sampleData
    
    func read() -> ResultType {
        return .Success(updatedData())
    }
    
    private func updatedData() -> [Person] {
        let updateWithNewBonuses = randomBonusUpdate(sampleData)
        var peopleWithNewBonuses = people
        
        updateWithNewBonuses.forEach { person in
            if let index = people.indexOf( {$0.name == person.name} ) {
                people[index] = people[index].copyPersonWithTotalBonus(person.bonus.total)
                peopleWithNewBonuses[index] = person
            }
        }
        
        return peopleWithNewBonuses
    }
}
