//
//  GeneralListCellViewModel.swift
//  GroceryList
//
//  Created by Omer Cohen on 7/31/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//

import Foundation
import UIKit

class GeneralListCellViewModel: GeneralListViewModelProtocol {
    
    var showContent: Bool
    var tableView: UITableView

    init(withTableView tableView: UITableView) {
        self.tableView = tableView
        self.showContent = false
    }
    
    func getMyCellType() -> TableViewCellTabCategory {return .temporaryCategory}

}
