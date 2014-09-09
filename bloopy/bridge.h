//
//  bridge.h
//  bloopy
//
//  Created by John Heaton on 9/6/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

#import <CoreMIDI/CoreMIDI.h>
#import <CoreFoundation/CoreFoundation.h>

void sendMIDIBytes(MIDIEndpointRef dest, MIDIPortRef outPort, UInt8 *bytes, UInt16 len);
MIDIPortRef _createInputPort(MIDIClientRef client, CFStringRef name, void (^closure)(UInt8 *buf, UInt16 len));