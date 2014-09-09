//
//  BufferArrayLiterals.swift
//  bloopy
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

import Foundation

extension UnsafeMutablePointer: ArrayLiteralConvertible {
    typealias Element = T
    
    static func fromArray(elements: [Element]) -> UnsafeMutablePointer<T> {
        var ptr = UnsafeMutablePointer<T>(malloc(UInt(elements.count)))
        for i in 0..<elements.count {
            ptr[i] = elements[i]
        }
        return ptr
    }
    
    public static func convertFromArrayLiteral(elements: Element...) -> UnsafeMutablePointer<T> {
        return fromArray(elements)
    }
}