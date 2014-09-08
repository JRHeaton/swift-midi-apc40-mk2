//
//  Source.swift
//  bloopy
//
//  Created by John Heaton on 9/7/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

extension MIDI {
    public struct Source: MIDIEnumerableObject, Printable {
        public let ref: MIDIEndpointRef
        
        // Enumeration
        public static var count: Int {
        	return Int(MIDIGetNumberOfSources())
        }
        public static func atIndex(index: Int) -> Source? {
            return index < count ? self(ref: MIDIGetSource(ItemCount(index))) : nil
        }
        
        // Disposing
        public func dispose() {
            MIDIEndpointDispose(ref)
        }
        
        // Printing
        public var description: String {
            return "MIDI Source: \(MIDI.name(self))"
        }
    }
}