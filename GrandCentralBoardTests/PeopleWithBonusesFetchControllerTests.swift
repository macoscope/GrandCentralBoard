//
//  PeopleWithBonusesFetchControllerTests.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 18/04/16.
//

import XCTest
import GrandCentralBoardCore
@testable import GrandCentralBoard


struct TestRequestSender: RequestSending {

    var bonuses: [Bonus]

    func sendRequestForRequestTemplate<T: RequestTemplateProtocol>(requestTemplate: T, completionBlock: ((Result<T.ResultType>) -> Void)?) {
        if let dateStringForBonusesRequestTemplate = requestTemplate.method.queryParameters["end_time"] {
            //bonuses request
            for bonus in bonuses {
                let dateFormatter = NSDateFormatter.init()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let date = dateFormatter.dateFromString(dateStringForBonusesRequestTemplate)!
                if date.timeIntervalSinceDate(bonus.date) > 0 {
                    completionBlock?(.Success([bonus] as! T.ResultType))
                    break
                }
            }
        } else {
            //gravatar request
            completionBlock?(.Success(UIImage.generatePlaceholderImage() as! T.ResultType))
        }
    }

}


class PeopleWithBonusesFetchControllerTests: XCTestCase {

    var fetchController: PeopleWithBonusesFetchController!
    var requestSender: RequestSending!

    override func setUp() {
        super.setUp()

        let createPerson = { (id: String) in
            return Person.init(id: id, name: "Rafal", email: "test@test.com", lastBonusDate: NSDate.init(), image: nil)
        }

        let createBonus = { (date: NSDate, person: Person) in
            return Bonus.init(name: "test name", amount: 1, receiver: person, date: date, childBonuses: [])
        }

        var bonuses = [Bonus]()

        for i in 1...100 {
            let identifier = String(i % 2 == 0 ? i : i - 1) //ensures that almost all people get more than 1 bonus
            let person = createPerson(identifier)
            let bonus = createBonus(NSDate.init(timeIntervalSince1970: NSTimeInterval(i)), person)
            bonuses.append(bonus)
        }

        requestSender = TestRequestSender(bonuses: bonuses.reverse())
        fetchController = PeopleWithBonusesFetchController(requestSending: self.requestSender, pageSize: 1, preferredNumberOfPeople: 10)
    }

    func testWhetherNextPagesAreFetchedWhenFirstOneDoesntContain10UniquePeople() {
        let expectation = expectationWithDescription("request")
        var fetchedPeople: [Person]?

        fetchController.fetchPeopleWithBonuses { result in
            switch result {
            case .Success(let people):
                fetchedPeople = people
            case .Failure:
                XCTAssertTrue(false)
            }
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(1.0) { error in
            XCTAssertTrue(fetchedPeople?.count == 10)
        }
    }
}
