//
//  Model.swift
//  GifOClock
//
//  Created by Pavel Dusatko on 2015-03-26.
//  Copyright (c) 2015 Themis Solutions Inc. All rights reserved.
//

import Foundation

public struct Gif {
    
    // MARK: - Properties
    
    public let id: String
    public let normalUrl: NSURL?
    public let smallUrl: NSURL?
    public let embedUrl: NSURL?
    public let smallWidth: Int
    public let smallHeight: Int
}
