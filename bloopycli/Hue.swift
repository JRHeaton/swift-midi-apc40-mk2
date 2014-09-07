//
//  Hue.swift
//  bloopy
//
//  Created by John Heaton on 9/6/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

import Foundation
import AppKit.NSColor

struct Light {
    static var username: String = "joanlikeslights"
    static var bridgeIP: String = "10.0.1.27"
    
    let location: Location
    var transitionTime: Int? // 100ms multiple
    
    enum Location: Int {
        case TV = 1
        case Window = 2
    }
    enum AlertType: String {
        case None = "none"
        case BlinkOnce = "select"
        case Blink30s = "lselect"
    }
    enum EffectType: String {
        case None = "none"
        case ColorLoop = "colorloop"
    }
    
    init(location: Location, transitionTime: Int? = nil) {
        self.location = location
        self.transitionTime = transitionTime
    }
    
    // ---------------------------------------------------
    func setState(params: [String:AnyObject]) {
        let req = NSMutableURLRequest(URL: NSURL(string: "http://\(Light.bridgeIP)/api/\(Light.username)/lights/\(location.toRaw())/state"))
        req.HTTPMethod = "PUT"
        var p = params
        if let t = transitionTime {
            if p["transitiontime"] == nil {
                p["transitiontime"] = transitionTime!
            }
        }
        req.HTTPBody = NSJSONSerialization.dataWithJSONObject(p, options: nil, error: nil)
        NSURLConnection.sendSynchronousRequest(req, returningResponse: nil, error: nil)
    }
    
    func off() {
        setState(["on":false])
    }
    func on() {
        setState(["on":true])
    }
    func setHue(hue: UInt16, saturation: UInt8? = nil, brightness: UInt8? = nil) {
        var params = ["hue":Int(hue)]
        if let s = saturation {
            params["sat"] = Int(s)
        }
        if let b = brightness {
            params["bri"] = Int(b)
        }
        setState(params)
    }
    func setBrightness(brightness: UInt8) {
        setState(["bri":Int(brightness)])
    }
    func alert(type: AlertType) {
        setState(["alert":type.toRaw()])
    }
    func effect(type: EffectType) {
        setState(["effect":type.toRaw()])
    }
    func setColor(color: NSColor) {
        let hue = UInt16(Float(color.hueComponent) * Float(UInt16.max))
        let saturation = UInt8(Float(color.saturationComponent) * 255)
        let brightness = UInt8(Float(color.brightnessComponent) * 255)
        setHue(hue, saturation: saturation, brightness: brightness)
    }
    func setWarmth(warmth: Int) {
        setState(["ct":warmth])
    }
}