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

class VicationCategoryCell: ModelCell {
    
    @IBOutlet var vvBtn: UIButton!
    @IBOutlet var nameCategorycell: UILabel!
    @IBOutlet var viewCheckBox: UIView!
    @IBOutlet var vvImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func setupView() {
        vvBtn.rx.tap.subscribe {  _ in
           let isSend = self.markCheckBox(pathString: TabCategoryEnum.vicationCategory.rawValue, name: self.items[0].name)
        }.disposed(by:self.disposeBag)
    }
}

