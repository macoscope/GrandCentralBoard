//
//  DailyProjectBillingStatsFetcher.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-18.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
import Decodable
import GCBCore
import GCBUtilities


final class DailyProjectBillingStatsFetcher {
    private let date: NSDate
    private let projectID: BillingProjectID
    private let account: String
    private let accessToken: AccessToken
    private let downloader: NetworkRequestManager

    init(date: NSDate, projectID: BillingProjectID, account: String, accessToken: AccessToken, downloader: NetworkRequestManager) {
        self.date = date
        self.projectID = projectID
        self.account = account
        self.accessToken = accessToken
        self.downloader = downloader
    }

    func fetchDailyProjectBillingStats(completion: (Result<[AnyObject]>) -> Void) {
        downloader.requestJSON(.GET, url: url, parameters: [:], headers: headers, encoding: .URL, completion: { result in
            switch result {
            case .Success(let json):
                guard let jsonArray = json as? [AnyObject] else {
                    let error = RawRepresentableInitializationError(type: [AnyObject].self, rawValue: json, object: json)
                    return completion(.Failure(error))
                }

                completion(.Success(jsonArray))

            case .Failure(let error):
                completion(.Failure(error))
            }
        })
    }

    private var url: NSURL {
        let formattedDate = date.stringWithFormat("yyyyMMdd")
        let urlString = String(format: "https://%@.harvestapp.com/projects/%d/entries?from=%@&to=%@",
                               account, projectID, formattedDate, formattedDate)

        return NSURL(string: urlString)!
    }

    private var headers: [String: String] {
        return ["Authorization": "Bearer " + accessToken.token, "Accept": "application/json"]
    }
}
