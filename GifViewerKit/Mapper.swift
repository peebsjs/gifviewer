//
//  Mapper.swift
//  GifOClock
//
//  Created by Pavel Dusatko on 2015-03-26.
//  Copyright (c) 2015 Themis Solutions Inc. All rights reserved.
//

import Foundation

func array(input: [String:AnyObject], key: String) -> [AnyObject]? {
    let maybeAny: AnyObject? = input[key]
    return maybeAny >>= { $0 as? [AnyObject] }
}

func dictionary(input: [String:AnyObject], key: String) -> [String:AnyObject]? {
    return input[key] >>= { $0 as? [String:AnyObject] }
}

func string(input: [String:AnyObject], key: String) -> String? {
    return input[key] >>= { $0 as? String }
}

func number(input: [NSObject:AnyObject], key: String) -> NSNumber? {
    return input[key] >>= { $0 as? NSNumber }
}

func int(input: [NSObject:AnyObject], key: String) -> Int? {
    return number(input,key).map { $0.integerValue }
}

func bool(input: [NSObject:AnyObject], key: String) -> Bool? {
    return number(input,key).map { $0.boolValue }
}

func asDict(x: AnyObject) -> [String:AnyObject]? {
    return x as? [String:AnyObject]
}

func toURL(urlString: String) -> NSURL? {
    return NSURL(string: urlString)
}

func curry<A,B,R>(f: (A,B) -> R) -> A -> B -> R {
    return { a in { b in f(a,b) } }
}

func curry<A,B,C,R>(f: (A,B,C) -> R) -> A -> B -> C -> R {
    return { a in { b in {c in f(a,b,c) } } }
}

func curry<A,B,C,D,R>(f: (A,B,C,D) -> R) -> A -> B -> C -> D -> R {
    return { a in { b in { c in { d in f(a,b,c,d) } } } }
}

func curry<A,B,C,D,E,R>(f: (A,B,C,D,E) -> R) -> A -> B -> C -> D -> E -> R {
    return { a in { b in { c in { d in { e in f(a,b,c,d,e) } } } } }
}

func curry<A,B,C,D,E,G,R>(f: (A,B,C,D,E,G) -> R) -> A -> B -> C -> D -> E -> G -> R {
    return { a in { b in { c in { d in { e in { g in f(a,b,c,d,e, g) } } } } } }
}

func join<A>(elements: [A?]) -> [A]? {
    var result: [A] = []
    for element in elements {
        if let x = element {
            result += [x]
        } else {
            return nil
        }
    }
    return result
}
