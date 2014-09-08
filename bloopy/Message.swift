//
//  Message.swift
//  bloopy
//
//  Created by John Heaton on 9/7/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

enum MIDIMessageType {
    case Channel
    case System
}

public protocol MIDIMessage {
    var status: UInt8 { get }
    var data1: UInt8 { get }
    var data2: UInt8 { get }
}
