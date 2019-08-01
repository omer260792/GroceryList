//
//  ItemCell.swift
//  GroceryList
//
//  Created by Omer Cohen on 7/31/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ItemCell: ModelCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var lineView: UIView!
    @IBOutlet var viewCell: UIView!
    @IBOutlet var imageViewCell: UIImageView!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var viewBtnOutlet: UIButton!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func setupView() {
        viewBtnOutlet.rx.tap.subscribe {  _ in
            self.toggleLine(pathString: "temporaryCategory")
            }.disposed(by:self.disposeBag)
    }
}
