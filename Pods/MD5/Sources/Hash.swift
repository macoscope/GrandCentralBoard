//
//  CryptoHash.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 07/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

public enum Hash {
    case md5(Array<UInt8>)

    public func calculate() -> [UInt8] {
        switch self {
        case md5(let bytes):
            return MD5(bytes).calculate()
        }
    }
}