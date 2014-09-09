//
//  OutputPort.swift
//  bloopy
//
//  Created by John Heaton on 9/7/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

extension MIDI {
    public struct OutputPort: MIDIObject, Printable, MIDIDisposable {
        public let ref: MIDIPortRef
        
        // Disposing
        public func dispose() -> Bool {
            return MIDIPortDispose(ref) == 0
        }
        
        // Printing
        public var description: String {
            return "MIDI Output Port: \(MIDI.name(self))"
        }
    }
}