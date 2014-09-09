//
//  Client.swift
//  bloopy
//
//  Created by John Heaton on 9/7/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

import Foundation

extension MIDI {
    public struct Client: MIDIObject, MIDIDisposable {
        public var ref: MIDIClientRef = 0
        public var outputPorts = [OutputPort]()
        public var inputPorts = [InputPort]()
        
        public init(name: String) {
            MIDIClientCreate(name as NSString as CFString, nil, nil, &ref)
        }
        
        // Output ports
        public mutating func createOutputPort(name: String) -> OutputPort? {
            var portRef: MIDIPortRef = 0
            var port: OutputPort? = nil
            if MIDIOutputPortCreate(ref, name as NSString as CFString, &portRef) == 0 {
            	port = OutputPort(ref: portRef)
                outputPorts.append(port!)
            }
            
            return port
        }
        public mutating func firstOutputPort() -> OutputPort? {
            if outputPorts.count == 0 {
                return createOutputPort("First")
            }
            
            return outputPorts.first
        }
        
        // Input ports
        public mutating func createInputPort(name: String) -> InputPort? {
            var port: InputPort? = nil
            var portRef = _createInputPort(ref, name as NSString as CFString) { buf, len in
                let msg = (buf[0], buf[1], buf[2])
				port?.channelVoiceHandler?(msg.0, msg.1, msg.2)
            }
            
            if portRef != 0 {
                port = InputPort(ref: portRef)
                inputPorts.append(port!)
            }
            
            return port
        }
        public mutating func firstInputPort() -> InputPort? {
            if inputPorts.count == 0 {
                return createInputPort("First")
            }
            
            return inputPorts.first
        }
        
        // Disposing
        public func dispose() -> Bool {
            return MIDIClientDispose(ref) == 0
        }
    }
}