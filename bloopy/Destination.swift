//
//  Destination.swift
//  bloopy
//
//  Created by John Heaton on 9/7/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

extension MIDI {
    public struct Destination: MIDIEnumerableObject, Printable, MIDIDisposable {
        public let ref: MIDIEndpointRef
        
        // Enumeration
        public static var count: Int {
        	return Int(MIDIGetNumberOfDestinations())
        }
        public static func atIndex(index: Int) -> Destination? {
            return index < count ? self(ref: MIDIGetDestination(ItemCount(index))) : nil
        }
        
        // Message sending
        public func sendChannelVoice(outPort: OutputPort, status: UInt8, data1: UInt8, data2: UInt8) {
            sendMIDIChannel(ref, outPort.ref, status, data1, data2)
        }
        public func sendMessage<T: MIDIMessage>(message: T, outPort: OutputPort) {
            sendMIDIChannel(ref, outPort.ref, message.status, message.data1, message.data2)
        }
        
        // Disposing
        public func dispose() -> Bool {
            return MIDIEndpointDispose(ref) == 0
        }
        
        // Printing
        public var description: String {
            return "MIDI Destination: \(MIDI.name(self))"
        }
    }
}