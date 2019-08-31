//
//  TemporeyViewController.swift
//  GroceryList
//
//  Created by Omer Cohen on 7/30/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//

import UIKit
import Firebase

class TemporeyViewController: GeneralListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
         setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupView(){
        // Navigation left
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "מחק" , style: .plain, target: self, action: nil)
        if let leftBtn = navigationItem.leftBarButtonItem {
            leftBtn.rx.tap.subscribe{ _ in
                self.modelCell.removeTemporaryList(pathString: TabCategoryEnum.temporaryCategory.rawValue)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    self.ref.observeSingleEvent(of: .value, with: { (snapshot) in
                        if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                            if snapshots.count == 0{
                                self.generalListTableDataBindingDisposable?.dispose()
                                self.tableUser.reloadData()
                            }
                        }
                    })
                })
            }.disposed(by: disposeBag)
        }
    }
}
