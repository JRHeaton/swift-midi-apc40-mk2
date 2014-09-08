//
//  Entity.swift
//  bloopy
//
//  Created by John Heaton on 9/7/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

import Foundation

extension MIDI {
    public struct Entity: MIDIObject, Printable {
        public let ref: MIDIEntityRef
        
        // Sources
        public var numberOfSources: Int {
            return Int(MIDIEntityGetNumberOfSources(ref))
        }
        public func sourceAtIndex(index: Int) -> Source? {
            return index < numberOfSources ? Source(ref: MIDIEntityGetSource(ref, ItemCount(index))) : nil
        }
        public subscript (index: Int) -> Source? {
            return sourceAtIndex(index)
        }
        public var sources: [MIDI.Source] {
            var ret: [MIDI.Source] = []
            for i in 0..<numberOfSources {
                if let src = sourceAtIndex(i) {
                    ret.append(src)
                }
            }
            return ret
        }
        
        // Destinations
        public var numberOfDestinations: Int {
            return Int(MIDIEntityGetNumberOfDestinations(ref))
        }
        public func destinationAtIndex(index: Int) -> Destination? {
            return index < numberOfDestinations ? Destination(ref: MIDIEntityGetDestination(ref, ItemCount(index))) : nil
        }
        public subscript (index: Int) -> Destination? {
            return destinationAtIndex(index)
        }
        public var destinations: [MIDI.Destination] {
            var ret: [MIDI.Destination] = []
            for i in 0..<numberOfDestinations {
                if let dest = destinationAtIndex(i) {
                    ret.append(dest)
                }
            }
        	return ret
        }
        
        // Printing
        public var description: String {
            return "MIDI Entity: \(MIDI.name(self))"
        }
    }
}