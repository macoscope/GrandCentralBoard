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

    private let peopleFetchController: PeopleWithBonusesFetchController

    init(bonuslyAccessToken: String, preferredNumberOfPeople: Int) {
        let configuration = RequestSenderConfiguration(queryParameters: ["access_token": bonuslyAccessToken])
        let requestSender = RequestSender(configuration: configuration)
        self.peopleFetchController = PeopleWithBonusesFetchController(requestSending:requestSender,
                                                                      dataDownloading: DataDownloader(),
                                                                      pageSize: 1,
                                                                      preferredNumberOfPeople: preferredNumberOfPeople)
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
