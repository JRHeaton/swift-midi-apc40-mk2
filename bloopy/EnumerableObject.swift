//
//  EnumerableObject.swift
//  bloopy
//
//  Created by John Heaton on 9/7/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

import Foundation

public protocol MIDIEnumerableObject: MIDIObject {
    class var count: Int { get }
    class func atIndex(index: Int) -> Self?
}

extension MIDI {
    // closure returns a boolean for whether to continue
    public static func enumerate<T: MIDIEnumerableObject>(closure: (T) -> Bool) {
        for i in 0..<T.count {
            if let object = T.atIndex(i) {
                if !closure(object) {
                    return
                }
            }
        }
    }
    
    public static func firstMeetingCriteria<T: MIDIEnumerableObject>(closure: (T) -> Bool) -> T? {
        var ret: T? = nil
        enumerate { (obj: T) -> Bool in
            if closure(obj) {
                ret = obj
                return false
            }
            return true
        }
        return ret
    }
    
    public static func firstNamed<T: MIDIEnumerableObject>(name: String, requireOnline: Bool = true) -> T? {
        return firstMeetingCriteria { (obj: T) -> Bool in
            return MIDI.name(obj) == name && (!requireOnline || MIDI.online(obj))
        }
    }
    
    public static func firstContainingName<T: MIDIEnumerableObject>(namePart: String, requireOnline: Bool = true) -> T? {
        return firstMeetingCriteria { (obj: T) -> Bool in
            return (MIDI.name(obj) as NSString).containsString(namePart) && (!requireOnline || MIDI.online(obj))
        }
    }
}