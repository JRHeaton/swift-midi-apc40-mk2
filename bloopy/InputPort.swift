//
//  InputPort.swift
//  bloopy
//
//  Created by John Heaton on 9/7/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

import Foundation

extension MIDI {
    public class InputPort: MIDIObject, Printable, MIDIDisposable {
        public let ref: MIDIPortRef
        
        public typealias InputHandler = (data: UnsafePointer<UInt8>, length: UInt16) -> ()
        public var inputHandler: InputHandler?
        
        public init(ref: MIDIPortRef, inputHandler: InputHandler? = nil) {
            self.ref = ref
            self.inputHandler = inputHandler
        }

        public init(client: MIDI.Client, name: String, inputHandler: InputHandler? = nil) {
            ref = 0
            self.inputHandler = inputHandler
            ref = _createInputPort(client.ref, name as NSString as CFString) { buf, len in
                let b = UnsafePointer<UInt8>(buf)
                self.inputHandler?(data: b, length: len)
            }
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