//
//  CategoryItemCell.swift
//  ShoppingList
//
//  Created by Omer Cohen on 6/14/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//
import Foundation
import RxCocoa
import RxSwift
import UIKit

class CategoryItemCell: ModelCell {
    
    @IBOutlet var isSendLabel: UILabel!
    @IBOutlet var imageViewItem: UIImageView!
    @IBOutlet var view: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var categoryStatusLabel: UILabel!
    @IBOutlet var categoryIsCompleted: UILabel!
    @IBOutlet var uidLabel: UILabel!
    @IBOutlet var secondCategroyLabel: UILabel!
    @IBOutlet var addPopupBtn: UIButton!
    @IBOutlet var viewCell: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func setupView() {
        addPopupBtn.rx.tap.subscribe {  _ in
            self.addItemToNewList(path: TabCategoryEnum.temporaryCategory.rawValue)
            }.disposed(by:self.disposeBag)
    }


}
    

