//
//  InputPort.swift
//  bloopy
//
//  Created by John Heaton on 9/7/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

extension MIDI {
    public struct InputPort: MIDIObject, Printable {
        public let ref: MIDIPortRef
        
        public typealias MessageHandler = (MIDIMessage) -> ()
        public var messageHandler: MessageHandler?
        
        init(ref: MIDIPortRef, messageHandler: MessageHandler? = nil) {
            self.ref = ref
            self.messageHandler = messageHandler
        }
        
        // Connecting sources
        public func connectSource(source: Source) {
            MIDIPortConnectSource(ref, source.ref, nil)
        }
        
        // Disposing
        public func dispose() {
            MIDIPortDispose(ref)
        }
        
        // Printing
        public var description: String {
            return "MIDI Input Port: \(MIDI.name(self))"
        }
    }
}