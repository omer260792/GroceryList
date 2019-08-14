//
//  VicationCell.swift
//  ShoppingList
//
//  Created by Omer Cohen on 7/1/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit
import Firebase

class VicationCell: ModelCell {

    @IBOutlet var binBtn: UIButton!
    @IBOutlet var viewCellBtn: UIButton!
    @IBOutlet var itemCategoryLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func setupView() {
        viewCellBtn.rx.tap.subscribe {  _ in
            if let name = self.itemCategoryLabel.text{
                self.toggleContent(pathString: TabCategoryEnum.vicationCategory.rawValue,name: name)
            }
        }.disposed(by:self.disposeBag)
        
        binBtn.rx.tap.subscribe {  _ in
            self.setAllMarkCheckboxEmpty(pathString: TabCategoryEnum.vicationCategory.rawValue, name: self.items[0].name)
        }.disposed(by:self.disposeBag)
    }
}
