//
//  Moya+Decodable.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 28.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Moya
import Decodable
import RxSwift


extension RxMoyaProvider {
    static func providerWithHeaders(headers: [String: String]) -> RxMoyaProvider {
        let endpointClosure: MoyaProvider<Target>.EndpointClosure = { target  in
            return MoyaProvider<Target>.DefaultEndpointMapping(target).endpointByAddingHTTPHeaderFields(headers)
        }
        return RxMoyaProvider(endpointClosure: endpointClosure)
    }
}

// MARK: - Decodable

extension Response {
    func mapDecodable<T: Decodable>() throws -> T {
        return try T.decode(mapJSON())
    }

    func mapDecodableArray<T: Decodable>() throws -> [T] {
        return try [T].decode(mapJSON())
    }
}

extension ObservableType where E == Response {
    func mapDecodable<T: Decodable>(type: T.Type) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(try response.mapDecodable())
        }
    }

    func mapDecodableArray<T: Decodable>(type: T.Type) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            return Observable.just(try response.mapDecodableArray())
        }
    }
}
