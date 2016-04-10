//
//  Created by Krzysztof Werys on 25/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import Foundation
import GrandCentralBoardCore


final class BonusSource : Asynchronous {
    
    typealias ResultType = Result<[Person]>

    let sourceType: SourceType = .Momentary
    let interval: NSTimeInterval = 5

    private let settings: BonusWidgetSettings
    private let peopleFetchController: PeopleWithBonususFetchController = PeopleWithBonususFetchController()

    init(settings: BonusWidgetSettings) {
        self.settings = settings
    }
    
    func read(closure: (ResultType) -> Void) {

        peopleFetchController.fetchPeopleWithBonuses { result in
            switch result {
            case .Success(let people):
                closure(.Success(people))
            case .Failure(let error):
                closure(.Failure(error))
            }
        }
    }
    
}
