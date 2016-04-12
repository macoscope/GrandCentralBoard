//
//  BonuslyRequestTemplate.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 07/04/16.
//

import Foundation
import Result


class BonuslyRequestTemplate<ResultType> : RequestTemplate<ResultType> {

    init(path: String, method: MethodType) {
        super.init(baseURL: NSURL.init(string: "https://www.bonus.ly/api/v1/")!, path: path, method: method)
    }

}


final class BonusesRequestTemplate : BonuslyRequestTemplate<[Bonus]> {

    init() {
        super.init(path: "bonuses", method: .Get(queryParameters: [:]))
    }

    override func finalizeWithResponse(response: NSURLResponse, result: AnyObject) throws -> [Bonus] {
        do {
            let bonuses = try Bonus.decodeBonuses(result)
            return bonuses
        } catch {
            throw RequestTemplateError.FinalizeError
        }
    }

}
