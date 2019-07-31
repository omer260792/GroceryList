//
//  TimeDataProvider.swift
//  GroceryList
//
//  Created by Omer Cohen on 7/31/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//

import Foundation

struct TimeDataProvider {
    
    
    // Mark: get the current time
    func currentTimeInSeconds()-> Int {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970)
    }
    
    
    // Mark: get the current time
    func currentTimeInSecondsSting()-> String {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return String(since1970)
    }
    
}

