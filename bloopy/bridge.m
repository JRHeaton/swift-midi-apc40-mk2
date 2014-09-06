//
//  bridge.c
//  bloopy
//
//  Created by John Heaton on 9/6/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

#include "bridge.h"

void sendMIDIChannel(MIDIEndpointRef dest, MIDIPortRef outPort, UInt8 status, UInt8 d1, UInt8 d2) {
    MIDIPacketList list;
    memset(&list, 0, sizeof(list));
    
    list.numPackets = 1;
    list.packet[0].length = 3;
    list.packet[0].timeStamp = 0;
    list.packet[0].data[0] = status;
    list.packet[0].data[1] = d1;
    list.packet[0].data[2] = d2;
    
    MIDISend(outPort, dest, &list);
}

static void _bloopyReadProc(const MIDIPacketList *pktlist, void *readProcRefCon, void *srcConnRefCon) {
    void (^closure)(UInt8 status, UInt8 d1, UInt8 d2) = (__bridge void (^)(UInt8, UInt8, UInt8))readProcRefCon;
    closure(pktlist->packet[0].data[0],pktlist->packet[0].data[1],pktlist->packet[0].data[2]);
}

MIDIPortRef _createInputPort(MIDIClientRef client, CFStringRef name, void (^closure)(UInt8 status, UInt8 d1, UInt8 d2)) {
    MIDIPortRef ret;
    MIDIInputPortCreate(client, name, _bloopyReadProc, (__bridge_retained void *)closure, &ret);
    return ret;
}