//
//  GeneralViewController.swift
//  GroceryList
//
//  Created by Omer Cohen on 7/31/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//

import UIKit

class GeneralViewController: GeneralListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
      self.dismissPickerView()
    }
    
    func setupView(){
        
        if let cencelBtn = cencelBtn {
            cencelBtn.rx.tap.subscribe{ _ in
                UIView.animate(withDuration: 0.3, animations: {
                    self.dismissPickerView()
                })
                }.disposed(by: disposeBag)
        }
        
        if let confirmBtn = confirmBtn {
            confirmBtn.rx.tap.subscribe{ _ in
                self.addPickerViewDelegate()
                UIView.animate(withDuration: 0.3, animations: {
                    self.groceryItemsCategory = GeneralCategoryEnum.secondCategory.rawValue
                    self.dismissPickerView()
                })
                }.disposed(by: disposeBag)
        }

        // Navigation left
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "פריט" , style: .plain, target: self, action: nil)
        if let leftBtn = navigationItem.leftBarButtonItem {
            leftBtn.rx.tap.subscribe{ _ in
                self.addPickerViewDelegate()
                UIView.animate(withDuration: 0.3, animations: {
                   self.showPickerView()
                })
            }.disposed(by: disposeBag)
        }
    }

}
