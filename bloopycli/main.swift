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
var outp = client.firstOutputPort()
var inp = client.firstInputPort() { s, d1, d2 in
 	println("status=\(s), d1=\(d1), d2=\(d2)")
    
    switch s {
    case 181:
        tv.setState(["hue":Int(Int(d2) * (65000 / 127))])
        window.setState(["hue":Int(Int(d2) * (65000 / 127))])
    case 182:
		tv.setState(["sat":Int(d2 * 2)])
        window.setState(["sat":Int(d2 * 2)])
    case 183:
        if d2 == 0 {
            window.off()
            tv.off()
        } else {
            window.on()
            tv.on()
            
            window.setBrightness(d2 * 2)
            tv.setBrightness(d2 * 2)
        }
    default: break
    }
}

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
            dest.send(client.firstOutputPort(), message: APCMessage.padOn(x: x, y: y, velocity: newValue))
        }
    }
}

if let source: MIDI.Source = MIDI.firstNamed("APC40 mkII") {
    source.connectToInputPort(inp)
}

if let dest: MIDI.Destination = MIDI.firstNamed("APC40 mkII") {
    var apc = APCConnection(client: client, dest: dest)
    apc[0, 0] = 20
}

CFRunLoopRun()