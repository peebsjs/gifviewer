//
//  Operators.swift
//  GifOClock
//
//  Created by Pavel Dusatko on 2015-03-26.
//  Copyright (c) 2015 Themis Solutions Inc. All rights reserved.
//

infix operator >>= {}
func >>= <A,B>(optional: A?, f: A -> B?) -> B? {
    return flatten(optional.map(f))
}

func flatten<A>(x: A??) -> A? {
    if let y = x { return y }
    return nil
}

infix operator <*> { associativity left precedence 150 }
func <*><A, B>(f: (A -> B)?, x: A?) -> B? {
    if let f1 = f {
        if let x1 = x {
            return f1(x1)
        }
    }
    return nil
}
