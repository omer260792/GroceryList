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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        self.delegate = delegate

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func setupView() {
        viewBtnOutlet.rx
            .longPressGesture()
            .when(.began, .changed, .ended)
            .subscribe(onNext: { pan in
                let view = pan.view
                let location = pan.location(in: view)
                switch pan.state {
                case .began:
                    if let delegate = self.delegate{
                    delegate.showEditCellPickerView()
                    }
                    print("began")
                case .changed:
                    print("changed \(location)")
                case .ended:
                    print("ended")
                default:
                    break
                }
            }).disposed(by: self.disposeBag)
        
        viewBtnOutlet.rx.tap.subscribe {  _ in
            self.toggleLine(pathString: "temporaryCategory")
            }.disposed(by:self.disposeBag)
        
    }
}
