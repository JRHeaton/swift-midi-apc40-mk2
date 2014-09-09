//
//  InputPort.swift
//  bloopy
//
//  Created by John Heaton on 9/7/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

extension MIDI {
    public struct InputPort: MIDIObject, Printable, MIDIDisposable {
        public let ref: MIDIPortRef
        
        public typealias ChannelVoiceHandler = (UInt8, UInt8, UInt8) -> ()
        public var channelVoiceHandler: ChannelVoiceHandler?
        
        init(ref: MIDIPortRef, channelVoiceHandler: ChannelVoiceHandler? = nil) {
            self.ref = ref
            self.channelVoiceHandler = channelVoiceHandler
        }
        
        // Connecting sources
        public func connectSource(source: Source) -> Bool {
            return MIDIPortConnectSource(ref, source.ref, nil) == 0
        }
        
        // Disposing
        public func dispose() -> Bool {
            return MIDIPortDispose(ref) == 0
        }
        
        // Printing
        public var description: String {
            return "MIDI Input Port: \(MIDI.name(self))"
        }
    }
}