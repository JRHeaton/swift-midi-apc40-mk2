//
//  Object.swift
//  bloopy
//
//  Created by John Heaton on 9/7/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

public protocol MIDIObject: Equatable {
    var ref: MIDIObjectRef { get }
}

public func == <T: MIDIObject> (left: T, right: T) -> Bool {
    return left.ref == right.ref
}

extension MIDI {
    public static func stringProperty<T: MIDIObject>(object: T, name: CFString) -> String? {
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
    
    public static func name<T: MIDIObject>(object: T) -> String {
        return stringProperty(object, name: kMIDIPropertyName)!
    }
}