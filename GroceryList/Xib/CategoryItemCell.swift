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
    
    @IBOutlet var imageViewItem: UIImageView!
    @IBOutlet var view: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var viewCell: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func setupView() {
        
        let viewCellTapGesture = UITapGestureRecognizer()
        viewCell.addGestureRecognizer(viewCellTapGesture)
        
        viewCellTapGesture.rx.event.bind(onNext: { recognizer in
            if self.items[0].isColor == true{
                self.updateAmountObject(pathString: TabCategoryEnum.generalCategory.rawValue, item: self.items, isColor: false)
            }else{
                self.delegate?.addObjectToVicationListFromGeneralList(item: [self.items[0]])
            }
        }).disposed(by: self.disposeBag)
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as? UIViewController
            }
        }
        return nil
    }
}
