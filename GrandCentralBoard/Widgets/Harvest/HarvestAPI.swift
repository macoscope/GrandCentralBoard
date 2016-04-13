//
//  HarvestAPI.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-12.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import GrandCentralBoardCore
import Alamofire


final class HarvestAPI {
    let oauthCredentials: OAuthCredentials
    let downloader: NetworkRequestManager = Alamofire.Manager.sharedInstance
    let dailyStatsURL = NSURL(string: "https://gcbtest.harvestapp.com/daily")!
    var headers: [String: String] {
        return ["Authorization": "Bearer " + oauthCredentials.accessToken, "Accept": "application/json"]
    }

    init(oauthCredentials: OAuthCredentials) {
        self.oauthCredentials = oauthCredentials
    }

    func fetchBillingStats(completion: (GrandCentralBoardCore.Result<[DailyBillingStats]>) -> Void) {
        fetchDailyBillingStats(NSDate()) { (result: GrandCentralBoardCore.Result<DailyBillingStats>) -> Void in
            switch result {
            case .Success(let dailyStats):
                completion(.Success([dailyStats]))

            case .Failure(let error):
                completion(.Failure(error))
            }
        }
    }

    func fetchDailyBillingStats(day: NSDate, completion: (GrandCentralBoardCore.Result<DailyBillingStats>) -> Void) {
        downloader.requestJSON(.GET, url: dailyStatsURL, parameters: [:], headers: headers, completion: { (result: ResultType<AnyObject, NSError>.result) -> Void in
            switch result {
            case .Success(let json):
                do {
                    let dailyStats = try DailyBillingStats.decode(json)
                    completion(.Success(dailyStats))

                } catch let error {
                    completion(.Failure(error))
                }

            case .Failure(let error):
                completion(.Failure(error))
            }
        })
    }

    func refreshTokenIfNeeded(completion: (GrandCentralBoardCore.Result<OAuthCredentials>) -> Void) {
        if (self.oauthCredentials.isTokenExpired) {
            refreshToken(completion)

        } else {
            completion(.Success(self.oauthCredentials))
        }
    }

    func refreshToken(completion: (GrandCentralBoardCore.Result<OAuthCredentials>) -> Void) {
        assertionFailure("Not implemented yet")
    }
}
