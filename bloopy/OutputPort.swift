//
//  OutputPort.swift
//  bloopy
//
//  Created by John Heaton on 9/7/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

extension MIDI {
    public struct OutputPort: MIDIObject, Printable {
        public let ref: MIDIPortRef
        
        // Disposing
        public func dispose() {
            MIDIPortDispose(ref)
        }
        
        // Printing
        public var description: String {
            return "MIDI Output Port: \(MIDI.name(self))"
        }
    }
}