//
//  LoginManager.swift
//  GroceryList
//
//  Created by Omer Cohen on 3/24/20.
//  Copyright © 2020 Omer Cohen. All rights reserved.
//

import Foundation

class LoginManager {
    class func isValidEmail(_ email: String) -> Bool {
        return email.count >= 5
    }
    
    class func isValidPassword(_ password: String) -> Bool {
        return password.count >= 5
    }
}
