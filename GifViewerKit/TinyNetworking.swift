//
//  TinyNetworking.swift
//  tiny-networking
//
//  Created by Chris Eidhof on 2015-02-14.
//
//  See the accompanying blog post: http://chris.eidhof.nl/posts/tiny-networking-in-swift.html

import Foundation

public enum Method: String { // Bluntly stolen from Alamofire
    case OPTIONS = "OPTIONS"
    case GET = "GET"
    case HEAD = "HEAD"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
    case TRACE = "TRACE"
    case CONNECT = "CONNECT"
}

public struct Resource<A> {
    let path: String
    let method : Method
    let parameters: [String: AnyObject]
    let headers : [String:String]
    let parse: NSData -> A?
    var urlString: String {
        get {
            return path + "?" + query(parameters)
        }
    }
}

public enum Reason {
    case CouldNotParseJSON
    case NoData
    case NoSuccessStatusCode(statusCode: Int)
    case Other(NSError)
}

public func apiRequest<A>(baseURL: NSURL, resource: Resource<A>, failure: (Reason, NSData?) -> (), completion: A -> ()) {
    let session = NSURLSession.sharedSession()
    let url = NSURL(string: resource.urlString, relativeToURL: baseURL)!
    let request = NSMutableURLRequest(URL: url)
    request.HTTPMethod = resource.method.rawValue
    for (key,value) in resource.headers {
        request.setValue(value, forHTTPHeaderField: key)
    }
    let task = session.dataTaskWithRequest(request){ (data, response, error) -> Void in
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                if let responseData = data {
                    if let result = resource.parse(responseData) {
                        dispatch_async(dispatch_get_main_queue(), {
                            completion(result)
                        })
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            failure(Reason.CouldNotParseJSON, data)
                        })
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        failure(Reason.NoData, data)
                    })
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    failure(Reason.NoSuccessStatusCode(statusCode: httpResponse.statusCode), data)
                })
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                failure(Reason.Other(error), data)
            })
        }
    }
    task.resume()
}

// Here are some convenience functions for dealing with JSON APIs

public typealias JSONDictionary = [String:AnyObject]

func decodeJSON(data: NSData) -> JSONDictionary? {
    return NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil) as? [String:AnyObject]
}

func encodeJSON(dict: JSONDictionary) -> NSData? {
    return dict.count > 0 ? NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.allZeros, error: nil) : nil
}

public func jsonResource<A>(path: String, method: Method, parameters: JSONDictionary, parse: JSONDictionary -> A?) -> Resource<A> {
    let f = { decodeJSON($0) >>= parse }
    let headers = ["Content-Type": "application/json"]
    return Resource(path: path, method: method, parameters: parameters, headers: headers, parse: f)
}

// Here are some convenience functions for dealing with URLs

func escape(string: String) -> String {
    let legalURLCharactersToBeEscaped: CFStringRef = ":/?&=;+!@#$()',*"
    return CFURLCreateStringByAddingPercentEscapes(nil, string, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as! String
}

func queryComponents(key: String, value: AnyObject) -> [(String, String)] {
    var components: [(String, String)] = []
    if let dictionary = value as? [String: AnyObject] {
        for (nestedKey, value) in dictionary {
            components += queryComponents("\(key)[\(nestedKey)]", value)
        }
    } else if let array = value as? [AnyObject] {
        for value in array {
            components += queryComponents("\(key)[]", value)
        }
    } else {
        components.extend([(escape(key), escape("\(value)"))])
    }
    
    return components
}

func query(parameters: [String: AnyObject]) -> String {
    var components: [(String, String)] = []
    for key in sorted(Array(parameters.keys), <) {
        let value: AnyObject! = parameters[key]
        components += queryComponents(key, value)
    }
    
    return join("&", components.map{"\($0)=\($1)"} as [String])
}

