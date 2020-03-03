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
    @IBOutlet var viewDesign: DesignableButton!
    var isToggle = false
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setupView() {
        viewButton.rx.tap.subscribe {  _ in
            print(self.isToggle)
            if let name = self.categoryLabel.text{
                self.isToggle = self.isToggle ? false : true

                self.toggleContent(pathString: "generalCategory", name: name, isToggle: self.isToggle)
            }
            }.disposed(by:self.disposeBag)
    }

}
