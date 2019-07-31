//
//  Enums.swift
//  GroceryList
//
//  Created by Omer Cohen on 7/30/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//

import Foundation


enum TabCategoryEnum: String {
    
    case generalCategory = "generalCategory"
    case temporaryCategory = "temporaryCategory"
    case vicationCategory = "vicationCategory"
    
    static let allValuesString = [generalCategory,temporaryCategory,vicationCategory]
}

enum generalCategoryEnum: String {
    
    case mainCategory = "mainCategory"
    case secondCategory = "secondCategory"
    
    static let allValuesString = [mainCategory,secondCategory]
}
