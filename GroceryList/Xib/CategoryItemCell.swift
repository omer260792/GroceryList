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
            
            let alert = UIAlertController(title: "Grocery Item",
                                          message: "Add an Item",
                                          preferredStyle: .alert)
            
            let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
                guard let textField = alert.textFields?.first,
                    var text = textField.text else { return }
                
                self.addItemToNewList(path: TabCategoryEnum.temporaryCategory.rawValue)

            }
            
            
            
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .cancel)
            
            alert.addTextField()
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)

            }.disposed(by:self.disposeBag)
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
