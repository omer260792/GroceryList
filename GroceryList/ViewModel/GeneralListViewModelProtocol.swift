//
//  GeneralListViewModelProtocol.swift
//  GroceryList
//
//  Created by Omer Cohen on 7/31/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//

import Foundation
import UIKit

protocol GeneralListViewModelProtocol {
    
    func getMyCellType() -> TableViewCellTabCategory
}

enum TableViewCellTabCategory {
    case temporaryCategory
    case generalCategory
    case vicationCategory
}
