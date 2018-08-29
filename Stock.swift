//
//  Stock.swift
//  MyStocks
//
//  Created by Matthew  Levis on 6/24/18.
//  Copyright © 2018 Matthew  Levis. All rights reserved.
//
//  Class for a Stock object of type NSObject

import Foundation

class Stock: NSObject {

    var sharePrice: Double?
    var highPrice: Double?
    var lowPrice: Double?
    var openPrice: Double?
    var closePrice: Double?
    var week52High: Double?
    var week52Low: Double?
    
    var symbol: String?
    var companyName: String?
    var sector: String?
    var primaryExchange: String?
    
    var peRatio: Double?
    var ytdChange: Double?
    var change: Double?
    var percentChange: String?
    
    var articles: [Article]? = []
    
}
