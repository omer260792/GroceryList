//
//  GeneralListViewController.swift
//  GroceryList
//
//  Created by Omer Cohen on 7/30/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa

class GeneralListViewController: UITableViewController, UITabBarControllerDelegate {

    @IBOutlet var tableView: UITableView!
    // MARK: Constants
    var listToUsers = "ListToUsers"
    var groceryItems = "grocery-items"
    var tabIndex = 0
    
    // MARK: Properties
    var items: [GroceryItem] = []
    var user: User!
    var userCountBarButtonItem: UIBarButtonItem!
    var ref = Database.database().reference(withPath: "groceryItems")
    let usersRef = Database.database().reference(withPath: "online")
    
    let timeDataProvider = TimeDataProvider()
    var generalListTableDataBindingDisposable: Disposable?
    let disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateRef()
        setNavigationTopBar()
        populateView()
        populateTableView()
    }
    
    func populateView() {
        
        self.tabBarController?.delegate = self
        tableView.allowsMultipleSelectionDuringEditing = false
        
        if self.tabBarController?.selectedIndex == 0 {
            tabIndex = 0
        } else if self.tabBarController?.selectedIndex == 1 {
            tabIndex = 1
        }else{
            tabIndex = 2
        }
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            
            let currentUserRef = self.usersRef.child(self.user.uid)
            currentUserRef.setValue(self.user.email)
            currentUserRef.onDisconnectRemoveValue()
        }
        
        usersRef.observe(.value, with: { snapshot in
            if snapshot.exists() {
                self.userCountBarButtonItem?.title = snapshot.childrenCount.description
            } else {
                self.userCountBarButtonItem?.title = "0"
            }
        })
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController is ViewController {
            listToUsers = "ViewController"
        }
        
        if viewController is JViewController {
            listToUsers = "JViewController"
        }
        
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateRef()
        ref.queryOrdered(byChild: "isCompleted").observe(.value, with: { snapshot in
            var newItems: [GroceryItem] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let groceryItem = GroceryItem(snapshot: snapshot) {
                    newItems.append(groceryItem)
                }
            }
            
            self.items = newItems
            self.tableView.reloadData()
        })
    }
    
    func updateRef(){
        switch  self.tabIndex {
        case 0:
            self.ref = Database.database().reference(withPath: TabCategoryEnum.generalCategory.rawValue)
        case 1:
            self.ref = Database.database().reference(withPath: TabCategoryEnum.vicationCategory.rawValue)
        case 2:
            self.ref = Database.database().reference(withPath: TabCategoryEnum.temporaryCategory.rawValue)
        default: break
        }
    }
    
    func populateTableView() {
        
//        tableView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: categoryCellIndentifier)
//
//        tableView.register(UINib(nibName: "CategoryItemCell", bundle: nil), forCellReuseIdentifier: categoryItemCellIndentifier)
//
//        extractGeneralListFromCoreDataAndFilterThemAccordingToGeneralListState(normalScheme: UpdateEnum.firstInitUpdate.rawValue)
//
//        if observableGeneralListEmptyObject.count > 0 {
//
//            generalListFromCoreData = Variable<[GeneralList]>.init(observableGeneralListEmptyObject)
//
//            bindDataForGeneralListTableView()
//        }
    }
    
    
    // MARK: UITableView Delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell2", for: indexPath)
    
        let groceryItem = items[indexPath.row]
       
  
        cell.textLabel?.text = groceryItem.name
        cell.detailTextLabel?.text = groceryItem.key
        toggleCellCheckbox(cell, isCompleted: groceryItem.isCompleted)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let groceryItem = items[indexPath.row]
            groceryItem.ref?.removeValue()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let groceryItem = items[indexPath.row]
        let toggledCompletion = !groceryItem.isCompleted
        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
        groceryItem.ref?.updateChildValues([
            "completed": toggledCompletion
            ])
    }
    
    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
        if !isCompleted {
            cell.accessoryType = .none
            cell.textLabel?.textColor = .black
            cell.detailTextLabel?.textColor = .black
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = .gray
            cell.detailTextLabel?.textColor = .gray
        }
    }
    
    func addButtonDidTouchT(category: String){
        let alert = UIAlertController(title: "Grocery Item",
                                      message: "Add an Item",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = alert.textFields?.first,
                let text = textField.text else { return }
            
            var tabCategory = ""
            
            switch  self.tabIndex {
            case 0:
                self.updateRef()
                tabCategory = TabCategoryEnum.generalCategory.rawValue
                
            case 1:
                self.updateRef()
                tabCategory = TabCategoryEnum.vicationCategory.rawValue
                
                
            case 2:
                self.updateRef()
                tabCategory = TabCategoryEnum.temporaryCategory.rawValue
                
            default:
                tabCategory = "3"
            }
            
            let groceryItem = GroceryItem(name: text, content: "", date: "", tabCategory: tabCategory, generalCategory: category, image: "", isSend: true, isColor: true, isCompleted: false, uid: "")
            
            let groceryItemRef = self.ref.child(text.lowercased())
            
            groceryItemRef.setValue(groceryItem.toAnyObject())
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Add Item
    @IBAction func addButtonDidTouch(_ sender: AnyObject) {
       
    }
    
    @objc func userCountButtonDidTouch() {
        performSegue(withIdentifier: listToUsers, sender: nil)
    }
    
    func setNavigationTopBar() {
        
        // Navigation title Color
        let navBarColor = UIColor(red: 205/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
        navigationController?.navigationBar.barTintColor = navBarColor
        
        // Navigation Title
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string:"רשימה כללית", attributes:[
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 27.0, weight: UIFont.Weight.bold)])
        navLabel.attributedText = navTitle
        navigationItem.titleView = navLabel
        
        // Navigation right
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "קטגוריה" , style: .plain, target: self, action: nil)
        if let rightBtn = navigationItem.rightBarButtonItem {
            rightBtn.rx.tap.subscribe{ _ in
                self.addButtonDidTouchT(category: GeneralCategoryEnum.mainCategory.rawValue)
                UIView.animate(withDuration: 0.3, animations: {
                   // self.AddGeneralItemView.alpha = 1
                  //  self.backgroundView.alpha = 0.7
                })
            }.disposed(by: disposeBag)
        }
        if tabIndex != 2 {
            // Navigation left
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "פריט" , style: .plain, target: self, action: nil)
            if let leftBtn = navigationItem.leftBarButtonItem {
                leftBtn.rx.tap.subscribe{ _ in
//                self.myArray = self.generaListViewModel.getGeneralCategoryName()
//
//                // Connect data:
//                self.addSecPickerView.delegate = self
//                self.addSecPickerView.dataSource = self
//
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.backgroundView.alpha = 0.7
//                    self.addSecCategoryViewPiker.alpha = 1
//
//                })
                }.disposed(by: disposeBag)
            }
        }
    }

}
