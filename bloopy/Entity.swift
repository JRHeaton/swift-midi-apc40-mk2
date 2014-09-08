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
        
        // Printing
        public var description: String {
            return "MIDI Entity: \(MIDI.name(self))"
        }
    }
}