//
//  BonusFetchController.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 07/04/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
import Result

let kPreferredPeopleCount = 10

enum PeopleWithBonususFetchControllerErrors : ErrorType {
    case NetworkError
    case IncorrectEmailAddress
    case Cancelled
}

class PeopleWithBonususFetchController {

    private let requestSender: RequestSender

    init(requestSender: RequestSender) {
        self.requestSender = requestSender
    }

    func fetchPeopleWithBonuses(completionBlock: (Result<[Person], PeopleWithBonususFetchControllerErrors>) -> Void) {
        fetchPeopleWithBonuses(startingFromDate: NSDate.init(), fetchedBonuses: [], completionBlock: { [weak self] result in
            guard let strongSelf = self else { return }

            switch result {
            case .Success(let people):
                strongSelf.fetchAvatarsForPeople(people, completionBlock: { result in
                    switch result {
                    case .Success(let people):
                        completionBlock(.Success(people))
                    case .Failure(let error):
                        completionBlock(.Failure(error))
                    }
                })
            case .Failure(let error):
                completionBlock(.Failure(error))
            }

        })
    }

    private func fetchPeopleWithBonuses(startingFromDate date: NSDate = NSDate.init(), fetchedBonuses: [Bonus], completionBlock: (Result<[Person], PeopleWithBonususFetchControllerErrors>) -> Void) {
        let take = 100
        let requestTemplate = TimestampableRequestTemplate<BonusesRequestTemplate>.init(requestTemplate: BonusesRequestTemplate(), date: date, take: take)
        
        requestSender.sendRequestForRequestTemplate(requestTemplate) { [weak self] result in
            guard let strongSelf = self else {
                completionBlock(.Failure(.Cancelled))
                return
            }

            switch result {
            case .Success(let bonuses):
                var allBonuses: [Bonus] = fetchedBonuses.reverse()
                allBonuses.appendContentsOf(bonuses)

                let people = allBonuses.reduce(Set<Person>(), combine: { people, bonus in
                    if people.count >= kPreferredPeopleCount {
                        return people
                    } else {
                        var mutablePeople = people
                        var receiver = bonus.receiver
                        receiver = receiver.copyWithLastBonusDate(bonus.date)
                        mutablePeople.insert(receiver)
                        return mutablePeople
                    }
                })

                if people.count >= kPreferredPeopleCount || bonuses.count < take {
                    completionBlock(.Success(Array(people)))
                } else if let lastBonus = bonuses.last {
                    strongSelf.fetchPeopleWithBonuses(startingFromDate: lastBonus.date, fetchedBonuses: allBonuses, completionBlock: completionBlock)
                }

            case .Failure(_):
                completionBlock(.Failure(PeopleWithBonususFetchControllerErrors.NetworkError))
            }
        }
    }

    private func fetchAvatarsForPeople(people: [Person], completionBlock: Result<[Person], PeopleWithBonususFetchControllerErrors> -> Void) {
        var peopleWithImages: [Person]? = [Person]()
        var groupError: PeopleWithBonususFetchControllerErrors?

        let group = dispatch_group_create()
        for person in people {
            dispatch_group_enter(group)
            updatePersonWithImageFromNetwork(person, completionBlock: { result in
                switch result {
                case .Success(let personWithImage):
                    peopleWithImages?.append(personWithImage)
                case .Failure(let error):
                    peopleWithImages = nil
                    groupError = error
                }
                dispatch_group_leave(group)
            })
        }

        dispatch_group_notify(group, dispatch_get_main_queue()) {
            if let peopleWithImages = peopleWithImages {
                completionBlock(.Success(peopleWithImages))
            } else {
                completionBlock(.Failure(groupError!))
            }
        }
    }

    private func updatePersonWithImageFromNetwork(person: Person, completionBlock: (Result<Person, PeopleWithBonususFetchControllerErrors>) -> Void) {
        guard let requestTemplate = GravatarImageRequesTemplate(email: person.email) else {
            completionBlock(.Failure(PeopleWithBonususFetchControllerErrors.IncorrectEmailAddress))
            return
        }

        requestSender.sendRequestForRequestTemplate(requestTemplate) { result in
            switch result {
            case .Success(let image):
                completionBlock(.Success(person.copyWithImage(image)))
            case .Failure:
                completionBlock(.Failure(PeopleWithBonususFetchControllerErrors.NetworkError))
            }
        }
    }
    
}
