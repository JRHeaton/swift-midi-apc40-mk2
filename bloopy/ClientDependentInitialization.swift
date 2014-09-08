//
//  ClientDependentInitialization.swift
//  bloopy
//
//  Created by John Heaton on 9/7/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

public protocol ClientDependentInitialization {
    init(client: MIDI.Client)
}

public protocol NamedClientDependentInitialization: ClientDependentInitialization {
    init(client: MIDI.Client, name: String)
}