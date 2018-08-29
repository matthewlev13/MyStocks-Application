//
//  IexAPI.swift
//  MyStocks
//
//  Created by Matthew  Levis on 8/26/18.
//  Copyright © 2018 Matthew  Levis. All rights reserved.
//
//  Struct for the IEX Api

import Foundation
import UIKit

struct IexAPI {
    
    
    // Fuction returns a URL to the IEX Api and takes in the stock symbol and type of query
    static func iexURL(symbol: String?, type: String?) -> URL {
        let baseURLString = "https://api.iextrading.com/1.0/stock/\(symbol!)/"
        switch type {
        case "quote":
            return URL(string: baseURLString + "quote")!
        case "news":
            return URL(string: baseURLString + "news")!
        default:
            preconditionFailure("Unrecognized function type.")
        }
    }
}
