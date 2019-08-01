//
//  VicationCategoryCell.swift
//  ShoppingList
//
//  Created by Omer Cohen on 7/23/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class VicationCategoryCell: UITableViewCell {
    
    
    @IBOutlet var viewCellBtn: UIButton!
    @IBOutlet var nameCategorycell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //setupCell()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}

