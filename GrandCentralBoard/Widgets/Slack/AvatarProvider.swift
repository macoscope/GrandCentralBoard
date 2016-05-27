//
//  AvatarProvider.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 27.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import Moya
import RxSwift

private struct SlackAvatarRequest: TargetType {
    let baseURL: NSURL
    let path = ""
    let method: Moya.Method = .GET
    let parameters: [String : AnyObject]? = nil
    let sampleData = NSData()

    init(url: NSURL) {
        baseURL = url
    }
}

private func AvatarEndpointMapping(target: SlackAvatarRequest) -> Endpoint<SlackAvatarRequest> {
    let url = target.baseURL.absoluteString
    return Endpoint(URL: url, sampleResponseClosure: {.NetworkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters)
}

final class AvatarProvider {

    private let moyaProvider = RxMoyaProvider<SlackAvatarRequest>(endpointClosure: AvatarEndpointMapping)

    func avatarWithURL(url: NSURL) -> Observable<UIImage!> {
        return moyaProvider.request(SlackAvatarRequest(url: url)).mapImage()
    }
}
