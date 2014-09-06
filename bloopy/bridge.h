//
//  bridge.h
//  bloopy
//
//  Created by John Heaton on 9/6/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

#import <CoreMIDI/CoreMIDI.h>
#import <CoreFoundation/CoreFoundation.h>

void sendMIDIChannel(MIDIEndpointRef dest, MIDIPortRef outPort, UInt8 status, UInt8 d1, UInt8 d2);
MIDIPortRef _createInputPort(MIDIClientRef client, CFStringRef name, void (^closure)(UInt8 status, UInt8 d1, UInt8 d2));