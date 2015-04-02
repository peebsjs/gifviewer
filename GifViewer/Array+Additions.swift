//
//  Array+Additions.swift
//  GifViewer
//
//  Created by Jason Peebles on 2015-04-02.
//  Copyright (c) 2015 Themis Solutions Inc. All rights reserved.
//

import Foundation

extension Array {
    func sample() -> T {
        let randomIndex = random() % count
        return self[randomIndex]
    }
}