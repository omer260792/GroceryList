//
//  SignUpViewController.swift
//  GroceryList
//
//  Created by Omer Cohen on 3/24/20.
//  Copyright © 2020 Omer Cohen. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    // MARK: Constants
    let loginToList = "LoginToList"
    
    private var viewModel: SignupViewModel!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SignupViewModel()
        
        Observable.combineLatest(emailTextField.rx.text.orEmpty, passwordTextField.rx.text.orEmpty) { email, password -> Bool in
            return LoginManager.isValidEmail(email) && LoginManager.isValidPassword(password)
        }
        .subscribe(onNext: { [weak self] isValid in
            isValid ? (self?.signupButton.isEnabled = true) : (self?.signupButton.isEnabled = false)
        }).disposed(by: bag)
        
        
        signupButton.rx.tap.map { [weak self] _ in
            return (self?.emailTextField.text ?? "", self?.passwordTextField.text ?? "")
        }
        .bind(to: viewModel.action.signup)
        .disposed(by: bag)
    }
    
//    internal func moveToMainPageVC(){
//        self.LoadSplashScreen()
//        self.performSegue(withIdentifier: self.loginToList, sender: nil)
//
//        //        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "MainListVC") as! MainListViewController
//        //        self.present(vc, animated: true, completion: nil)
//    }
    
    internal func LoadSplashScreen() {
         let myView = Bundle.main.loadNibNamed("splashScreen", owner: nil, options: nil)![0] as! UIView
         let width = UIScreen.main.bounds.size.width
         let height = UIScreen.main.bounds.size.height
         myView.frame = CGRect(x: 0, y: 0, width: width, height: height)
         view.addSubview(myView)
     }
}

extension SignUpViewController {
    class func signup(email: String, password: String, completion: @escaping    (Result<AuthDataResult,Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let result = result {
                completion(.success(result))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    internal func moveToMainPageVC(){
        self.LoadSplashScreen()
        self.performSegue(withIdentifier: self.loginToList, sender: nil)
        
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "MainListVC") as! MainListViewController
        //        self.present(vc, animated: true, completion: nil)
    }
}
