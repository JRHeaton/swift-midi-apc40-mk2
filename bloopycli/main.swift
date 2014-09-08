//
//  main.swift
//  bloopycli
//
//  Created by John Heaton on 9/5/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

import Foundation
import bloopy

var tv 		= Light(location: .TV)
var window 	= Light(location: .Window)

var client = MIDI.Client(name: "Default")
var outp = client.firstOutputPort()!
var inp = client.firstInputPort()!

println(client)
println(outp)
println(inp)

struct APCMessage: MIDIMessage {
    let status, data1, data2: UInt8
    
    static func padOn(#x: UInt8, y: UInt8, velocity: UInt8) -> APCMessage {
        return APCMessage(status: 0x90, data1: x + 0x20 - (y * 8), data2: velocity)
    }
}

struct APCConnection {
    var client: MIDI.Client
    let dest: MIDI.Destination
    
    subscript (x: UInt8, y: UInt8) -> UInt8 {
        get { return 0 }
        set {
//            dest.sendChannelVoice(outp, message: APCMessage.padOn(x: x, y: y, velocity: newValue))
        }
    }
}

if let source: MIDI.Source = MIDI.firstNamed("APC40 mkII") {
    inp.connectSource(source)
}

if let dest: MIDI.Destination = MIDI.firstNamed("APC40 mkII") {
    var apc = APCConnection(client: client, dest: dest)
    dest.sendChannelVoice(outp, status: 0x90, data1: 0x16, data2: 110)
//    apc[0, 0] = 65
}

CFRunLoopRun()