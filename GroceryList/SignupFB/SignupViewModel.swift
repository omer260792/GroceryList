//
//  SignupViewModel.swift
//  GroceryList
//
//  Created by Omer Cohen on 3/24/20.
//  Copyright © 2020 Omer Cohen. All rights reserved.
//

import UIKit
import RxSwift
import Firebase

struct SignupViewModel {
    
    struct State {
    }
    
    struct Action {
        let signup = PublishSubject<(String, String)>()
    }
    
    let state = State()
    let action = Action()
    private let bag = DisposeBag()
    
    init() {
        action.signup.subscribe(onNext: { email, password in
            SignUpViewController.signup(email: email, password: password, completion: { result in
                switch result {
                case .success:
                    print("omer success")
                case .failure(let error):
                    print("omer", error)
                }
            })
        }).disposed(by: bag)
    }
}



