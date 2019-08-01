//
//  TimeDataProvider.swift
//  GroceryList
//
//  Created by Omer Cohen on 7/31/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//

import Foundation

class TimeDataProvider {
    
    // Mark: get the current time
    static func currentTimeInSeconds()-> Int {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970)
    }
    
    // Mark: get the current time
    static func currentTimeInSecondsSting()-> String {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return String(Int(since1970))
    }
    
}

