//
//  bridge.c
//  bloopy
//
//  Created by John Heaton on 9/6/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

#include "bridge.h"

void sendMIDIBytes(MIDIEndpointRef dest, MIDIPortRef outPort, const UInt8 *bytes, UInt16 len) {
    MIDIPacketList list;
    memset(&list, 0, sizeof(list));
    
    list.numPackets = 1;
    list.packet[0].length = len;
    list.packet[0].timeStamp = 0;
    
#define MIN(a, b) ((a) < (b) ? (a) : (b))
    memcpy(list.packet[0].data, bytes, MIN(sizeof(list.packet[0].data), len));
    
    MIDISend(outPort, dest, &list);
}

static void _bloopyReadProc(const MIDIPacketList *packetList, void *readProcRefCon, void *srcConnRefCon) {
    void (^closure)(UInt8 *, UInt16) = (__bridge void (^)(UInt8*, UInt16))readProcRefCon;
    if (!closure) return;
    
    const MIDIPacket *packet = &packetList->packet[0];
    for (int i=0;i<packetList->numPackets;++i) {
        UInt8 *buf = (UInt8 *)packet->data;
        closure(buf, packet->length);
        
        packet = MIDIPacketNext(packet);
    }
}

MIDIPortRef _createInputPort(MIDIClientRef client, CFStringRef name, void (^closure)(UInt8 *, UInt16)) {
    MIDIPortRef ret;
    MIDIInputPortCreate(client, name, _bloopyReadProc, (__bridge_retained void *)closure, &ret);
    return ret;
}