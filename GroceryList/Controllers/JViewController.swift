//
//  JViewController.swift
//  GroceryList
//
//  Created by Omer Cohen on 7/30/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//

import UIKit

class GeneralViewController: GeneralListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("tabIndex",tabIndex)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("tabIndex2",tabIndex)
        
    }
    


}
