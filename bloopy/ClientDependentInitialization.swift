//
//  ClientDependentInitialization.swift
//  bloopy
//
//  Created by John Heaton on 9/7/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

public protocol NamedClientDependentInitialization {
    init(client: MIDI.Client, name: String)
}