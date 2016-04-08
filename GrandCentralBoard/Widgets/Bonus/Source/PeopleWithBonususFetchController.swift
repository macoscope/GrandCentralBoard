//
//  BonusFetchController.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 07/04/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
import Result


enum PeopleWithBonususFetchControllerErrors : ErrorType {
    case NetworkError
    case Cancelled
}

class PeopleWithBonususFetchController {

    let requestSender: RequestSender = RequestSender()

    func fetchPeopleWithBonuses(completionBlock: (Result<[Person], PeopleWithBonususFetchControllerErrors>) -> Void) {
        fetchPeopleWithBonuses(startingFromDate: NSDate.init(), fetchedBonuses: [], completionBlock: completionBlock)
    }

    private func fetchPeopleWithBonuses(startingFromDate date: NSDate = NSDate.init(), fetchedBonuses: [Bonus], completionBlock: (Result<[Person], PeopleWithBonususFetchControllerErrors>) -> Void) {
        let take = 100
        let requestTemplate = TimestampableRequestTemplate<BonusesRequestTemplate>.init(requestTemplate: BonusesRequestTemplate(), date: date, take: take)
        let requestSender = RequestSender();
        requestSender.sendRequestForRequestTemplate(requestTemplate) { [weak self] result in
            guard let strongSelf = self else {
                completionBlock(.Failure(.Cancelled))
                return
            }

            switch result {
            case .Success(let bonuses):
                var allBonuses = fetchedBonuses
                allBonuses.appendContentsOf(bonuses)

                let people = allBonuses.reduce(Set<Person>(), combine: { people, bonus in
                    if people.count >= 10 {
                        return people
                    } else {
                        var mutablePeople = people
                        mutablePeople.insert(bonus.receiver)
                        return mutablePeople
                    }
                })

                if people.count >= 10 || bonuses.count < take {
                    completionBlock(.Success(Array(people)))
                } else if let lastBonus = bonuses.last {
                    strongSelf.fetchPeopleWithBonuses(startingFromDate: lastBonus.date, fetchedBonuses: allBonuses, completionBlock: completionBlock)
                }

            case .Failure(_):
                completionBlock(.Failure(PeopleWithBonususFetchControllerErrors.NetworkError))
            }
        }
    }

}
