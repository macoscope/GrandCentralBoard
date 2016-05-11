//
//  WebsocketAddressResponse.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 11.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import Decodable


struct SlackRTMStartResponse {
    let websocketURL: NSURL
}

extension SlackRTMStartResponse: Decodable {

    static func decode(json: AnyObject) throws -> SlackRTMStartResponse {
        let urlString: String = try json => "url"
        if let url = NSURL(string: urlString) {
            return SlackRTMStartResponse(websocketURL: url)
        } else {
            throw RawRepresentableInitializationError(type: NSURL.self, rawValue: urlString, object: json)
        }
    }
}
