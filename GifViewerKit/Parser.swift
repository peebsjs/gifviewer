//
//  Parser.swift
//  GifOClock
//
//  Created by Pavel Dusatko on 2015-03-26.
//  Copyright (c) 2015 Themis Solutions Inc. All rights reserved.
//

func parseSearch(dict: JSONDictionary) -> Gifs? {
    return array(dict, "data") >>= {
        join($0.map(parseGif))
    }
}

func parseGif(gif: AnyObject) -> Gif? {
    let mappedGif = curry { id, normalUrl, smallUrl, embedUrl, smallWidth, smallHeight in Gif(id: id, normalUrl: normalUrl, smallUrl: smallUrl, embedUrl: embedUrl, smallWidth: smallWidth, smallHeight: smallHeight) }
    return asDict(gif) >>= {
        mappedGif
            <*> string($0, "id")
            <*> (string(dictionary(dictionary($0, "images")!, "fixed_width")!, "url") >>= toURL)
            <*> (string(dictionary(dictionary($0, "images")!, "fixed_width_small")!, "url") >>= toURL)
            <*> (string($0, "embed_url") >>= toURL)
            <*> (string(dictionary(dictionary($0, "images")!, "fixed_width_small")!, "width"))!.toInt()
        <*> (string(dictionary(dictionary($0, "images")!, "fixed_width_small")!, "height"))!.toInt()
    }
}
