//
//  File.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 11.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import GrandCentralBoardCore


enum SlackTarget: TargetType {
    case GetWebsocketAddress

    var baseURL: NSURL { return NSURL(string: "https://slack.com/api")! }

    var path: String {
        switch self {
        case .GetWebsocketAddress: return "/rtm.start"
        }
    }

    var parameters: [String : AnyObject]? { return nil }
    var method: Moya.Method { return .GET }
    var sampleData: NSData { return NSData() }
}

enum SlackError: ErrorType, HavingMessage {
    case IncorrectWebsocketURL(String)

    var message: String {
        switch self {
        case .IncorrectWebsocketURL(let urlString): return "Got incorrect websocket URL: \(urlString)"
        }
    }
}

final class SlackRestAPIProvider {

    private let moyaProvider: RxMoyaProvider<SlackTarget>

    init(accessToken: String) {
        moyaProvider = RxMoyaProvider.providerWithHeaders([:], parameters: ["token": accessToken])
    }

    func websocketAddress() -> Observable<NSURL> {
        return moyaProvider.request(.GetWebsocketAddress).mapDecodable(SlackRTMStartResponse).map {
            $0.websocketURL
        }
    }
}
