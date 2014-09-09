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
        public mutating func createInputPort(name: String, inputHandler: InputPort.InputHandler? = nil) -> InputPort? {
            let p = InputPort(client: self, name: name, inputHandler: inputHandler)
            inputPorts.append(p)
            return p
        }
        public mutating func firstInputPort(inputHandler: InputPort.InputHandler? = nil) -> InputPort? {
            if inputPorts.count == 0 {
                return createInputPort("First", inputHandler)
            }
            
            return inputPorts.first
        }
        
        // Disposing
        public func dispose() -> Bool {
            return MIDIClientDispose(ref) == 0
        }
    }
}