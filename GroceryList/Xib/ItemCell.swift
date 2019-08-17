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
import RxGesture

class ItemCell: ModelCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var lineView: UIView!
    @IBOutlet var viewCell: UIView!
    @IBOutlet var imageViewCell: UIImageView!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var viewBtnOutlet: UIButton!
    @IBOutlet var showImagebtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        self.delegate = delegate
        self.collectionModel = collectionModel
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func setupView() {
        
        showImagebtn.rx.tap.subscribe{_ in
            print(self.lineView.tag)
            self.downloadImage(pathString: TabCategoryEnum.temporaryCategory.rawValue, name: self.items[0].key)
            
        }.disposed(by: self.disposeBag)
        
        viewBtnOutlet.rx
            .longPressGesture()
            .when(.began)
            .subscribe(onNext: { pan in
                let view = pan.view

                let location = pan.location(in: view)
                switch pan.state {
                case .began:
                    if let delegate = self.delegate{
                        delegate.showEditCellPickerView(index: self.lineView.tag)
                    }
                    print("began")
                default:
                    break
                }
            }).disposed(by: self.disposeBag)
        
        viewBtnOutlet.rx.tap.subscribe {  _ in
            self.toggleLine(pathString: "temporaryCategory")
            }.disposed(by:self.disposeBag)
        
    }
    
    
    

}
