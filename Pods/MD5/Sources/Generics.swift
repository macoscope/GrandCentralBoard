//
//  Generics.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 02/09/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

/** Protocol and extensions for integerFromBitsArray. Bit hakish for me, but I can't do it in any other way */
protocol Initiable  {
    init(_ v: Int)
    init(_ v: UInt)
}

extension Int:Initiable {}
extension UInt:Initiable {}
extension UInt8:Initiable {}
extension UInt16:Initiable {}
extension UInt32:Initiable {}
extension UInt64:Initiable {}

/// Array of bytes, little-endian representation. Don't use if not necessary.
/// I found this method slow
func arrayOfBytes<T>(value:T, length:Int? = nil) -> [UInt8] {
    let totalBytes = length ?? sizeof(T)
    
    let valuePointer = UnsafeMutablePointer<T>.alloc(1)
    valuePointer.memory = value
    
    let bytesPointer = UnsafeMutablePointer<UInt8>(valuePointer)
    var bytes = [UInt8](count: totalBytes, repeatedValue: 0)
    for j in 0..<min(sizeof(T),totalBytes) {
        bytes[totalBytes - 1 - j] = (bytesPointer + j).memory
    }
    
    valuePointer.destroy()
    valuePointer.dealloc(1)
    
    return bytes
}

// MARK: - shiftLeft

// helper to be able tomake shift operation on T
func << <T:SignedIntegerType>(lhs: T, rhs: Int) -> Int {
    let a = lhs as! Int
    let b = rhs
    return a << b
}

func << <T:UnsignedIntegerType>(lhs: T, rhs: Int) -> UInt {
    let a = lhs as! UInt
    let b = rhs
    return a << b
}

// Generic function itself
func shiftLeft<T: SignedIntegerType where T: Initiable>(value: T, count: Int) -> T {
    if (value == 0) {
        return 0;
    }
    
    let bitsCount = (sizeofValue(value) * 8)
    let shiftCount = Int(Swift.min(count, bitsCount - 1))
    
    var shiftedValue:T = 0;
    for bitIdx in 0..<bitsCount {
        let bit = T(IntMax(1 << bitIdx))
        if ((value & bit) == bit) {
            shiftedValue = shiftedValue | T(bit << shiftCount)
        }
    }
    
    if (shiftedValue != 0 && count >= bitsCount) {
        // clear last bit that couldn't be shifted out of range
        shiftedValue = shiftedValue & T(~(1 << (bitsCount - 1)))
    }
    return shiftedValue
}

// for any f*** other Integer type - this part is so non-Generic
func shiftLeft(value: UInt, count: Int) -> UInt {
    return UInt(shiftLeft(Int(value), count: count))
}

func shiftLeft(value: UInt8, count: Int) -> UInt8 {
    return UInt8(shiftLeft(UInt(value), count: count))
}

func shiftLeft(value: UInt16, count: Int) -> UInt16 {
    return UInt16(shiftLeft(UInt(value), count: count))
}

func shiftLeft(value: UInt32, count: Int) -> UInt32 {
    return UInt32(shiftLeft(UInt(value), count: count))
}

func shiftLeft(value: UInt64, count: Int) -> UInt64 {
    return UInt64(shiftLeft(UInt(value), count: count))
}

func shiftLeft(value: Int8, count: Int) -> Int8 {
    return Int8(shiftLeft(Int(value), count: count))
}

func shiftLeft(value: Int16, count: Int) -> Int16 {
    return Int16(shiftLeft(Int(value), count: count))
}

func shiftLeft(value: Int32, count: Int) -> Int32 {
    return Int32(shiftLeft(Int(value), count: count))
}

func shiftLeft(value: Int64, count: Int) -> Int64 {
    return Int64(shiftLeft(Int(value), count: count))
}

