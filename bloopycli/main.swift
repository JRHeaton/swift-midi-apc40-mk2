//
//  main.swift
//  bloopycli
//
//  Created by John Heaton on 9/5/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

import Foundation
import bloopy

var client = MIDI.Client(name: "APC Fun")
if let apc: MIDI.Device = MIDI.firstContainingName("APC40", requireOnline: true) {
    let dest = apc.entityAtIndex(0)!.destinations.first
    let src = apc.entityAtIndex(0)!.sourceAtIndex(0)!
	var inp = client.firstInputPort()!
    inp.inputHandler =  { buf, len in
        for i in 0..<len {
            let hex = NSString(format: "%02x", buf[Int(i)])
            print("\(hex) ")
        }
        println("")
    }
    inp.connectSource(src)

	dest?.sendBytes(client.firstOutputPort()!, bytes: 0x90, 0x14, 112)
}

CFRunLoopRun()