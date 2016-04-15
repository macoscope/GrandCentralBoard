//
//  Created by Krzysztof Werys on 25/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import Foundation
import GrandCentralBoardCore


final class BonusSource : Asynchronous {
    
    typealias ResultType = Result<[Person]>

    let sourceType: SourceType = .Momentary
    let interval: NSTimeInterval = 10

    private let peopleFetchController: PeopleWithBonususFetchController

    init(bonuslyAccessToken: String) {
        let requestSender = RequestSender(configuration: RequestSenderConfiguration.init(queryParameters: ["access_token": bonuslyAccessToken]))
        self.peopleFetchController = PeopleWithBonususFetchController.init(requestSender: requestSender)
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
