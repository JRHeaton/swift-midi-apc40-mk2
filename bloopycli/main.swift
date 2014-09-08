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
    inp.channelVoiceHandler = { s, d1, d2 in
        println("\(s), \(d1), \(d2)")
    }
    inp.connectSource(src)
}

CFRunLoopRun()