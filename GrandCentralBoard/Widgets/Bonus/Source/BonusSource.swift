//
//  Created by Krzysztof Werys on 25/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import Foundation
import GCBCore


final class BonusSource: Asynchronous {

    typealias ResultType = Result<[Person]>

    let sourceType: SourceType = .Momentary
    let interval: NSTimeInterval = 10

    private let peopleWithBonuses: PeopleWithBonusesProviding

    init(peopleWithBonuses: PeopleWithBonusesProviding) {
        self.peopleWithBonuses = peopleWithBonuses
    }

    func read(closure: (ResultType) -> Void) {

        peopleWithBonuses.fetchPeopleWithBonuses { result in
            switch result {
            case .Success(let people):
                closure(.Success(people))
            case .Failure(let error):
                closure(.Failure(error))
            }
        }
    }

}
