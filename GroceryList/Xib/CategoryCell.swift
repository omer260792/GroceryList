//
//  CategoryCell.swift
//  ShoppingList
//
//  Created by Omer Cohen on 6/14/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit
import Firebase

class CategoryCell: ModelCell {
    
    @IBOutlet var categoryImgView: UIImageView!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var viewButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setupView() {
        viewButton.rx.tap.subscribe {  _ in
            if let name = self.categoryLabel.text{
                self.toggleContent(pathString: "generalCategory", name: name)
            }
            }.disposed(by:self.disposeBag)
    }

}
