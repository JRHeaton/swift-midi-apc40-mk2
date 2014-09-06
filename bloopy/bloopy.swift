//
//  bloopy.swift
//  bloopy
//
//  Created by John Heaton on 9/5/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

import Foundation
import CoreMIDI

public protocol MIDIObject {
    var ref: MIDIObjectRef { get }
}

public protocol MIDIEnumerableObject: MIDIObject {
    class var count: Int { get }
    class func atIndex(index: Int) -> Self?
}

public protocol MIDIMessage {
    var status: UInt8 { get }
    var data1: UInt8 { get }
    var data2: UInt8 { get }
}

public struct MIDI {
    public struct Client: MIDIObject {
        public var ref: MIDIClientRef = 0
        public var outputPorts = [MIDIPortRef]()
        public var inputPorts = [MIDIPortRef]()
        
        public init(name: String) {
            MIDIClientCreate(name as NSString as CFString, nil, nil, &ref)
        }
        
        public mutating func createOutputPort(name: String) -> MIDIPortRef {
            var port: MIDIPortRef = 0
            MIDIOutputPortCreate(ref, name as NSString as CFString, &port)
            outputPorts.append(port)
            return port
        }
        
        public mutating func firstOutputPort() -> MIDIPortRef {
        	if outputPorts.count == 0 {
            	return createOutputPort("First")
        	}
        
        	return outputPorts.first!
        }
        
        public typealias inputMessageHandler = ((status: UInt8, data1: UInt8, data2: UInt8) -> ())
        public mutating func createInputPort(name: String, closure: inputMessageHandler) -> MIDIPortRef {
            var port = _createInputPort(ref, name as NSString as CFStringRef, closure)
            inputPorts.append(port)
            return port
        }
        
        public mutating func firstInputPort(closure: inputMessageHandler) -> MIDIPortRef {
            if inputPorts.count == 0 {
                return createInputPort("First", closure)
            }
            
            return inputPorts.first!
        }
    }

    public struct Source: MIDIEnumerableObject {
        public let ref: MIDIEndpointRef
        
        public static var count: Int {
        	return Int(MIDIGetNumberOfSources())
        }
        public static func atIndex(index: Int) -> Source? {
            return index < count ? self(ref: MIDIGetSource(ItemCount(index))) : nil
        }
        
        public func connectToInputPort(port: MIDIPortRef) {
            MIDIPortConnectSource(port, ref, nil)
        }
    }
    
    public struct Destination: MIDIEnumerableObject {
        public let ref: MIDIEndpointRef
        
        public static var count: Int {
        	return Int(MIDIGetNumberOfDestinations())
        }
        public static func atIndex(index: Int) -> Destination? {
            return index < count ? self(ref: MIDIGetDestination(ItemCount(index))) : nil
        }
        
        public func send(outPort: MIDIPortRef, status: UInt8, data1: UInt8, data2: UInt8) {
            sendMIDIChannel(ref, outPort, status, data1, data2)
        }
        
        public func send<T: MIDIMessage>(outPort: MIDIPortRef, message: T) {
            sendMIDIChannel(ref, outPort, message.status, message.data1, message.data2)
        }
    }
    
    public struct Device: MIDIEnumerableObject {
        public let ref: MIDIDeviceRef
        
        public static var count: Int {
        	return Int(MIDIGetNumberOfDevices())
        }
        public static func atIndex(index: Int) -> Device? {
            return index < count ? self(ref: MIDIGetDevice(ItemCount(index))) : nil
        }
    }

    public static func enumerate<T: MIDIEnumerableObject>(closure: (T) -> Bool) {
        for i in 0..<T.count {
            if let object = T.atIndex(i) {
                if !closure(object) {
                    return
                }
            }
        }
    }
    
    public static func stringProperty<T: MIDIEnumerableObject>(object: T, name: CFString) -> String? {
        var _cfProp: Unmanaged<CFString>?
        if MIDIObjectGetStringProperty(object.ref, name, &_cfProp) == 0 {
            if let cfProp = _cfProp {
                let ret = String(cfProp.takeUnretainedValue())
                cfProp.release()
                return ret
            }
        }
        return nil
    }
    
    public static func name<T: MIDIEnumerableObject>(object: T) -> String {
        return stringProperty(object, name: kMIDIPropertyName)!
    }
    
    public static func firstNamed<T: MIDIEnumerableObject>(name: String) -> T? {
        for i in 0..<T.count {
            if let obj = T.atIndex(i) {
                if MIDI.name(obj) == name {
                    return obj
                }
            }
        }
        return nil
    }
}

extension MIDI.Device: Printable {
    public var description: String {
        return "Device: \(MIDI.name(self))"
    }
}

extension MIDI.Destination: Printable {
    public var description: String {
        return "Destination: \(MIDI.name(self))"
    }
}

extension MIDI.Source: Printable {
    public var description: String {
        return "Source: \(MIDI.name(self))"
    }
}