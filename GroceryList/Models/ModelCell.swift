//
//  modelCell.swift
//  GroceryList
//
//  Created by Omer Cohen on 7/31/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ModelCell: UITableViewCell {
    
    let disposeBag = DisposeBag()
    var delegate: GeneralListViewController?
    var viewModel: GeneralListCellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func setupView() {

    }
    
    func setLabels() {
       
    }
    
    func toggleContent(){
        
       
            viewModel?.showContent = true
            
            print(viewModel?.showContent)
            print(viewModel?.getMyCellType())
        
    }
    
    func fillCellData(){
        setLabels()
    }
    
}
