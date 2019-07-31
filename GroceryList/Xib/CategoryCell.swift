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

class CategoryCell: UITableViewCell {
    
    @IBOutlet var categoryImgView: UIImageView!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var viewButton: UIButton!
    
    var delegate: GeneralListViewController!
    let disposeBag = DisposeBag()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        populateSetupXib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func populateSetupXib(){
        viewButton.rx.tap.subscribe {  _ in
            
            self.delegate.SelectCategoryString = self.categoryLabel.text!
            self.delegate.ReloadCategoryUpdateTableView()

            }.disposed(by:self.disposeBag)
    }
    
}
