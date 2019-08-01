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

    @IBOutlet var viewCellBtn: UIButton!
    @IBOutlet var itemCategoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func setupView() {
        viewCellBtn.rx.tap.subscribe {  _ in
            self.toggleContent(pathString: "vicationCategory")
        }.disposed(by:self.disposeBag)
    }
}
