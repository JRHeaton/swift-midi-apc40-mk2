//
//  Device.swift
//  bloopy
//
//  Created by John Heaton on 9/7/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

extension MIDI {
    public struct Device: MIDIEnumerableObject, Printable, MIDIDisposable {
        public let ref: MIDIDeviceRef
        
        // Enumeration
        public static var count: Int {
        	return Int(MIDIGetNumberOfDevices())
        }
        public static func atIndex(index: Int) -> Device? {
            return index < count ? self(ref: MIDIGetDevice(ItemCount(index))) : nil
        }
        
        // Entities
        public var numberOfEntities: Int {
            return Int(MIDIDeviceGetNumberOfEntities(ref))
        }
        public func entityAtIndex(index: Int) -> Entity? {
            return index < numberOfEntities ? Entity(ref: MIDIDeviceGetEntity(ref, ItemCount(index))) : nil
        }
        public subscript (index: Int) -> Entity? {
            return entityAtIndex(index)
        }
        public var entities: [Entity] {
            var ret: [Entity] = []
            for i in 0..<numberOfEntities {
                if let dest = entityAtIndex(i) {
                    ret.append(dest)
                }
            }
            return ret
        }
        
        // Disposing
        public func dispose() -> Bool {
            return MIDIDeviceDispose(ref) == 0
        }
        
        // Printing
        public var description: String {
            return "MIDI Device: \(MIDI.name(self))"
        }
    }
}