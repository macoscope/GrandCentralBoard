//
//  TimestampableRequestTemplate.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 07/04/16.
//

import Foundation
import Result


class TimestampableRequestTemplate<T: RequestTemplateProtocol> : RequestTemplateProtocol {

    let requestTemplate: T
    let date: NSDate
    let take: Int

    init(requestTemplate: T, date: NSDate, take: Int) {
        self.requestTemplate = requestTemplate
        self.date = date
        self.take = take
    }

    var baseURL: NSURL {
        get {
            return requestTemplate.baseURL
        }
    }

    var path: String {
        get {
            return requestTemplate.path
        }
    }

    var method: MethodType {
        get {
            let dateFormatter = NSDateFormatter.init()
            dateFormatter.locale = NSLocale.init(localeIdentifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            dateFormatter.timeZone = NSTimeZone.init(name: "UTC")

            var method = requestTemplate.method
            method.addQueryParameter("startTime", value: dateFormatter.stringFromDate(date))
            method.addQueryParameter("limit", value: String(take))
            return method
        }
    }

    var responseResultType: ResponseResultType {
        get {
            return requestTemplate.responseResultType
        }
    }

    func finalizeWithResponse(response: NSURLResponse, result: AnyObject) throws -> T.ResultType {
        return try self.requestTemplate.finalizeWithResponse(response, result: result)
    }

}
