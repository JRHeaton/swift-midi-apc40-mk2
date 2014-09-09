//
//  main.swift
//  bloopycli
//
//  Created by John Heaton on 9/5/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

import Foundation
import bloopy

let CC_BANK_8: UInt8		= 0xb7
let bank8knobs: [UInt8] 	= [0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17]

let lights = [Light(location: .TV), Light(location: .Window)]

var client = MIDI.Client(name: "APC Fun")
if let apc: MIDI.Device = MIDI.firstContainingName("APC40", requireOnline: true) {
    let dest = apc.entityAtIndex(0)!.destinations.first
    let src = apc.entityAtIndex(0)!.sourceAtIndex(0)!
	var inp = client.firstInputPort()!
    
    var buttonDown = false
    var bri: UInt8 = 0
    var hue: UInt8 = 0
    var sat: UInt8 = 0
    inp.inputHandler =  { buf, len in
        for i in 0..<len {
            let hex = NSString(format: "%02x", buf[Int(i)])
            print("\(hex) ")
        }
        println("")
        
        if buf[1] == 0x07 {
        	buttonDown = buf[0] == 0x90
            if buttonDown {
                for light in lights {
                    if bri == 0 {
                        light.off()
                    } else {
                        println("applying hsb: (\(hue),\(sat),\(bri))")
                        light.on()
                        light.setState(["hue":(Int(hue)*65000)/255,"sat":Int(sat),"bri":Int(bri)])
                    }
                }
            }
        }
        
        if buf[0] == CC_BANK_8 {
            println("buf[2] is \(buf[2])")
            
            switch buf[1] {
            case 0x14: hue = buf[2] * 2
            case 0x15: sat = buf[2] * 2
            case 0x16: bri = buf[2] * 2
                
            default: break
            }
        }
    }
    inp.connectSource(src)

	dest?.sendBytes(client.firstOutputPort()!, bytes: 0x90, 0x14, 112)
}

CFRunLoopRun()