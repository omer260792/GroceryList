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

class GeneralListViewController: UIViewController, UITabBarControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource  {
    //Temporey List iboutlet
    @IBOutlet var viewTemporery: UIView?
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var backgrondView: UIView!
    @IBOutlet var tableUser: UITableView!
    @IBOutlet var confirmBtn: UIButton!
    @IBOutlet var cencelBtn: UIButton!
    @IBOutlet var picker: UIPickerView!
    @IBOutlet var pikerView: UIView?
    @IBOutlet var listCategoryLabel: UILabel!
    
    // MARK: Constants
    var listToUsers = "ListToUsers"
    var groceryItemsCategory = "grocery-items"
    var tabIndex = 0
    var tabCategory = TabCategoryEnum.temporaryCategory.rawValue
    var nameOfCategoryString = ""
    var cellTestIndex: Int = 0
    var titlePage = ""

    // MARK: Properties
    var items: [GroceryItem] = []
    var itemsCount: [GroceryItem] = []
    var itemsEmpty: [GroceryItem] = []
    var user: User!
    var userCountBarButtonItem: UIBarButtonItem!
    var ref = Database.database().reference(withPath: "groceryItems")
    let usersRef = Database.database().reference(withPath: "online")
    let modelCell = ModelCell()
    let timeDataProvider = TimeDataProvider()
    var vicationViewModel: VicationViewModel?
    let categoryCellIndentifier = "CategoryCellIdentifier"
    let categoryItemCellIndentifier = "CategoryItemCellIndentifier"
    let itemCellIndentifier = "ItemCellIndentifier"
    let vicationCategoryCellIndentifier = "VicationCategoryCellIdentifier"
    let vicationCellIndentifier = "VicationCellIndentifier"
    
    // MARK: rxswift
    var generalListTableDataBindingDisposable: Disposable?
    let disposeBag = DisposeBag()
    var observableGeneralListEmptyObject = Variable<[GroceryItem]>([]).value
    var generalListFromCoreData = Variable<[GroceryItem]>([])
    var observableGeneralList = Observable<[GroceryItem]>.empty()
    var generalListObsevaleTableView = Observable<[GroceryItem]>.empty()
    
    var myArrayCategoryName: Array<String> = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vicationViewModel = VicationViewModel(withTableView: tableUser)
        updateRef()
        setNavigationTopBar()
        populateView()
        setupGeneralListTableViewCellWhenDeleted()
        setupGeneralListTableViewCellWhenTapped()
    }
    
    func getImageFromDir(_ imageName: String) -> UIImage? {
        
        if let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsUrl.appendingPathComponent(imageName)
            do {
                let imageData = try Data(contentsOf: fileURL)
                return UIImage(data: imageData)
            } catch {
                print("Not able to load image")
            }
        }
        return nil
    }

    func populateView() {
        
        self.tableUser.backgroundView = UIImageView(image: UIImage(named: "Untitled-1.png"))
        
        self.tableUser.backgroundColor?.withAlphaComponent(0.4)
        
        self.tableUser.separatorStyle = .none
        
        self.tableUser.register(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: self.categoryCellIndentifier)
        
        self.tableUser.register(UINib(nibName: "CategoryItemCell", bundle: nil), forCellReuseIdentifier: self.categoryItemCellIndentifier)
        
         self.tableUser.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: self.itemCellIndentifier)
        
         self.tableUser.register(UINib(nibName: "VicationCategoryCell", bundle: nil), forCellReuseIdentifier: self.vicationCategoryCellIndentifier)
        
         self.tableUser.register(UINib(nibName: "VicationCell", bundle: nil), forCellReuseIdentifier: self.vicationCellIndentifier)
        
        self.tabBarController?.delegate = self
        
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
        
        if viewController is VicatoinViewController {
            listToUsers = "ViewController"
        }
        
        if viewController is GeneralViewController {
            listToUsers = "JViewController"
        }
        
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateRef()
        populateTableView()
    }
    
    func updateRef(){
        switch  self.tabIndex {
        case 0:
            self.ref = Database.database().reference(withPath: TabCategoryEnum.temporaryCategory.rawValue)
            self.tabCategory = TabCategoryEnum.temporaryCategory.rawValue
            self.titlePage = TabCategoryEnum.temporaryCategory.rawValue
        case 1:
            self.ref = Database.database().reference(withPath: TabCategoryEnum.generalCategory.rawValue)
            self.tabCategory = TabCategoryEnum.generalCategory.rawValue
            self.titlePage = TabCategoryEnum.generalCategory.rawValue
        case 2:
            self.ref = Database.database().reference(withPath: TabCategoryEnum.vicationCategory.rawValue)
            self.tabCategory = TabCategoryEnum.vicationCategory.rawValue
            self.titlePage = TabCategoryEnum.vicationCategory.rawValue
        default: break
        }
    }
    
    func getCell(forTableView tableView: UITableView, andIndexPath indexPath: IndexPath, elemntData: GroceryItem) -> UITableViewCell {
        let element = elemntData
        tableView.rowHeight = 60
        switch element.tabCategory {
        case "generalCategory":
            
            if element.generalCategory == GeneralCategoryEnum.mainCategory.rawValue{
                tableView.rowHeight = Constanst.Cell.general_main_category_height_constants
               let cell = self.tableUser.dequeueReusableCell(withIdentifier: categoryCellIndentifier, for: indexPath) as! CategoryCell
                cell.categoryLabel.text = element.key
                cell.items = [element]
                cell.delegate = self
                cell.viewDesign.backgroundColor =  Constanst.Cell.color_app_cell_main_general_constants
                if element.isCompleted == true{
                    arrowAnimate(num: 1, animationDuration: 0.44, cell: cell)
                }else{
                    arrowAnimate(num: 0, animationDuration: 0.44, cell: cell)
                }
                return cell
            }else{
                let cell = self.tableUser.dequeueReusableCell(withIdentifier: categoryItemCellIndentifier, for: indexPath) as! CategoryItemCell
                    cell.items = [element]
                    cell.delegate = self
                isColorCell(cell: cell, isColor: element.isColor)
                if element.isCompleted == true {
                    tableView.rowHeight = Constanst.Cell.general_sec_category_height_constants
                    cell.titleLabel.text = element.key
                }else{
                    tableView.rowHeight = 0
                }
                return cell
            }
            
        case "temporaryCategory":
            
            let cell = self.tableUser.dequeueReusableCell(withIdentifier: itemCellIndentifier, for: indexPath) as! ItemCell
            
                cell.items = [element]
                if element.isCompleted == true {
                    cell.lineView.isHidden = false
                }else{
                    cell.lineView.didMoveToSuperview()
                    cell.lineView.isHidden = true
                }
                cell.titleLabel.text = element.key
                cell.contentLabel.text = element.content
            return cell
            
        case "vicationCategory":
            
            if element.generalCategory == GeneralCategoryEnum.mainCategory.rawValue{
                let cell = self.tableUser.dequeueReusableCell(withIdentifier: vicationCellIndentifier, for: indexPath) as! VicationCell
                    cell.itemCategoryLabel.text = element.key
                    cell.items = [element]
                return cell
            }else{
                let cell = self.tableUser.dequeueReusableCell(withIdentifier: vicationCategoryCellIndentifier, for: indexPath) as! VicationCategoryCell
                cell.items = [element]
                if element.isCompleted == true {
                    tableView.rowHeight = 0
                }else{
                    tableView.rowHeight = 60
                    cell.nameCategorycell.text = element.key
                }
                if element.isSend == true {
                    cell.vvImgView.isHidden = false
                }else{
                    cell.vvImgView.isHidden = true
                }
                return cell
             }
            
        default:
            return UITableViewCell()
        }
    }
    
    func arrowAnimate(num: CGFloat, animationDuration: TimeInterval, cell:CategoryCell){
        var transform: CGAffineTransform
        if num == 0 {
            transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2.0)
        }else{
            transform =  CGAffineTransform.identity
        }
        tableUser.beginUpdates()
        UIView.animate(withDuration: animationDuration, animations: {
            //let transform = CGAffineTransform(rotationAngle: CGFloat(Double(num) * .pi/180))
            cell.categoryImgView.transform = transform
        }) { (finish) in
           // cell.arrowImagaeRotationAngle =  CGFloat.pi * num
        }
        tableUser.endUpdates()
    }

    func bindDataForGeneralListTableView() {
        self.generalListTableDataBindingDisposable = generalListObsevaleTableView
            .bind(to: tableUser.rx.items) { (tableView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                self.cellTestIndex = indexPath.row
                let cell = self.getCell(forTableView: tableView, andIndexPath: indexPath, elemntData: element )
                return cell
        }
        self.generalListTableDataBindingDisposable?.disposed(by: self.disposeBag)
    }
    
    func populateTableView() {
        ref.queryOrdered(byChild: "isCompleted").observe(.value, with: { snapshot in
            var newItems: [GroceryItem] = []
            self.myArrayCategoryName = [String]()
            self.itemsCount = self.itemsEmpty
            self.observableGeneralListEmptyObject.removeAll()
            self.generalListObsevaleTableView = Observable<[GroceryItem]>.empty()
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let groceryItem = GroceryItem(snapshot: snapshot) {
                    
                    if let value = snapshot.value as? [String: AnyObject] {
                        
                        let object = value["object"] as? [String: AnyObject]
                        
                        if let objSec = object{
                            for (key, value) in objSec{
                            
                                let name =  value["name"] as? String ?? ""
                                let content =  value["content"] as? String ?? ""
                                let date =  value["date"] as? String ?? ""
                                let tabCategory =  value["tabCategory"] as? String ?? ""
                                let generalCategory =  value["generalCategory"] as? String ?? ""
                                let image =  value["image"] as? String ?? ""
                                let isSend =  value["isSend"] as? Bool ?? false
                                let isColor =  value["isColor"] as? Bool ?? false
                                let isCompleted =  value["isCompleted"] as? Bool ?? false
                                let uid =  value["uid"] as? String ?? ""
                                
                                let groceryItem = GroceryItem(name: name, content: content, date: date, tabCategory: tabCategory, generalCategory: generalCategory, image: image, isSend: isSend, isColor: isColor, isCompleted: isCompleted, uid: uid, key: key)
                                
                                    newItems.append(groceryItem)
                                self.observableGeneralListEmptyObject.append(groceryItem)

                            }
                        }
                    }
                    newItems.append(groceryItem)
                    self.observableGeneralListEmptyObject.append(groceryItem)
                    if groceryItem.generalCategory == GeneralCategoryEnum.mainCategory.rawValue{                        
                        self.myArrayCategoryName.append(groceryItem.name)
                        self.itemsCount.append(groceryItem)
                    }
                }
            }
            
            var generalListObjectSorted  = Variable(self.observableGeneralListEmptyObject).value
            generalListObjectSorted.sort { (item1, item2) -> Bool in
                
                if self.tabCategory == TabCategoryEnum.temporaryCategory.rawValue {
                    return item1.date < item2.date
                }else{
                    if item1.uid == item2.uid{
                        return item1.date < item2.date
                    }
                    return item1.uid < item2.uid
                }
            }
            
            self.items = generalListObjectSorted
            
            self.generalListObsevaleTableView = Observable.of(generalListObjectSorted)
            
            if self.observableGeneralListEmptyObject.count > 0 {
                self.generalListTableDataBindingDisposable?.dispose()
                self.bindDataForGeneralListTableView()
            }
        })
    }
    
    private func setupGeneralListTableViewCellWhenDeleted() {
        tableUser.rx.itemDeleted
            .subscribe(onNext : { indexPath in
                if self.tabCategory == TabCategoryEnum.temporaryCategory.rawValue {
                    if self.items[indexPath.row].generalCategory == GeneralCategoryEnum.secondCategory.rawValue{
                        self.modelCell.updateGeneralListCellColor(pathString: TabCategoryEnum.generalCategory.rawValue, grocObjKey: self.items[indexPath.row].key, name: self.items[indexPath.row].name)
                    }
                
                    if self.items.count == 1{
                        self.removeObjectFromFirebase(indexPath: indexPath)
                        self.generalListTableDataBindingDisposable?.dispose()
                    }else{
                        self.removeObjectFromFirebase(indexPath: indexPath)
                    }

                }else if self.items[indexPath.row].generalCategory == GeneralCategoryEnum.mainCategory.rawValue {
                    let groceryItem = self.items[indexPath.row]

                    self.modelCell.updateGeneralListAndVicationListNameCategory(pathString: groceryItem.tabCategory, indexPath: indexPath, item: self.items)
                    groceryItem.ref?.removeValue()
                }else if self.items[indexPath.row].generalCategory == GeneralCategoryEnum.secondCategory.rawValue{
                    let groceryItem = self.items[indexPath.row]

                    let reff = Database.database().reference(withPath: groceryItem.tabCategory).child(self.items[indexPath.row].name).child("object").child(self.items[indexPath.row].key)
                    
                    reff.removeValue(){ (error, ref) -> Void in
                        if error != nil {
                            print("oops, an error")
                        } else {
                            print("completed")
                        }
                    }
                }
                self.tableUser.reloadData()
            })
        .disposed(by: disposeBag)
    }
    
    func removeObjectFromFirebase(indexPath: IndexPath){
        let groceryItem = self.items[indexPath.row]
        groceryItem.ref?.removeValue()
   
    }
    
    func isColorCell(cell: CategoryItemCell, isColor: Bool) {
        if isColor {
            cell.backgroundColor = Constanst.Cell.color_app_cell_second_general_constants
            cell.contentView.alpha = 0.7
            cell.titleLabel.textColor = .gray
        } else {
            cell.backgroundColor = .clear
            cell.titleLabel.textColor = .black
        }
    }
    
    func isToggleCell(cell: UITableViewCell, element: GroceryItem, tableView: UITableView) {
        if element.isCompleted {
            tableView.rowHeight = 0
        } else {
           tableView.rowHeight = 70
        }
    }
    
    func addPopUpView(category: String, title: String, msg: String){
        let alert = UIAlertController(title: title,
                                      message: msg,
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "שמור", style: .default) { _ in
            guard let textField = alert.textFields?.first,
                let text = textField.text else { return }
            
            self.updateRef()
            self.ref.child(text).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChildren(){
                    print("true rooms exist")
                }else{
                    if category == GeneralCategoryEnum.mainCategory.rawValue {
                        self.saveMainCategory(text: text)
                    }else{
                        self.saveSecondCategory(text: text)
                    }
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "ביטול",
                                         style: .cancel)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    func saveMainCategory(text: String){
    
        let uid = text
        let name = text
        
        getIndexTab()

        let groceryItem = GroceryItem(name: name, content: "", date: TimeDataProvider.currentTimeInSecondsSting(), tabCategory: self.tabCategory, generalCategory: GeneralCategoryEnum.mainCategory.rawValue, image: "", isSend: false, isColor: false, isCompleted: false, uid: uid)

        let groceryItemRef = self.ref.child(text.lowercased())

        groceryItemRef.setValue(groceryItem.toAnyObject()){ (error, ref) -> Void in
            if error != nil {
                print("oops, an error")
            } else {
                print("completed")
            }
        }
    }
    
    func saveSecondCategory(text: String){
 
        getIndexTab()

        let uid = self.nameOfCategoryString+GeneralCategoryEnum.secondCategory.rawValue
        let name = self.nameOfCategoryString
        
        let groceryItem = GroceryItem(name: name, content: "", date: TimeDataProvider.currentTimeInSecondsSting(), tabCategory: self.tabCategory, generalCategory: GeneralCategoryEnum.secondCategory.rawValue, image: "", isSend: false, isColor: false, isCompleted: false, uid: uid)

        let groceryItemRef = self.ref.child(name)

        groceryItemRef.child("object").child(text.lowercased()).setValue(groceryItem.toAnyObject()){ (error, ref) -> Void in

            if error != nil {
                print("oops, an error")
            } else {
                print("completed")
            }
        }
    }
    
    func getIndexTab(){
        switch  self.tabIndex {
        case 0:
            self.tabCategory = TabCategoryEnum.temporaryCategory.rawValue
        case 1:
            self.tabCategory = TabCategoryEnum.generalCategory.rawValue
        case 2:
            self.tabCategory = TabCategoryEnum.vicationCategory.rawValue
            
        default:
            self.tabCategory = "3"
        }
    }
    
    func save(text: String, category: String){
        var uid: String
        var name :String
        getIndexTab()
        
        if category == GeneralCategoryEnum.mainCategory.rawValue {
            uid = text
            name = text
        }else{
            uid = self.nameOfCategoryString+GeneralCategoryEnum.secondCategory.rawValue
            name = self.nameOfCategoryString
        }

        let groceryItem = GroceryItem(name: name, content: "", date: TimeDataProvider.currentTimeInSecondsSting(), tabCategory: self.tabCategory, generalCategory: category, image: "", isSend: false, isColor: false, isCompleted: false, uid: uid)

        let groceryItemRef = self.ref.child(text.lowercased())

        groceryItemRef.child("").setValue(groceryItem.toAnyObject()){ (error, ref) -> Void in

            if error != nil {
                print("oops, an error")
            } else {
                print("completed")
            }
        }
    }
    
    
    @objc func userCountButtonDidTouch() {
        performSegue(withIdentifier: listToUsers, sender: nil)
    }
    
    func setNavigationTopBar() {
        UINavigationBar.appearance().isTranslucent = false

        // Navigation title Color
        let navBarColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
        navigationController?.navigationBar.barTintColor = navBarColor
        
        if self.tabBarController?.selectedIndex == 0 {
            tabIndex = 0
            self.titlePage = "רשימת קניות"
        } else if self.tabBarController?.selectedIndex == 1 {
            tabIndex = 1
            self.titlePage = "רשימה כללית"
        }else{
            tabIndex = 2
            self.titlePage = "מה לקחת לחופשה:)"
        }
        
        // Navigation Title
        let navLabel = UILabel()
        navLabel.font = UIFont(name: "heebo_regular", size: 20.0)
        navLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        navLabel.text = self.titlePage
        navigationItem.titleView = navLabel
        
        // Navigation right
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "קטגוריה" , style: .plain, target: self, action: nil)
        if let rightBtn = navigationItem.rightBarButtonItem {
            rightBtn.rx.tap.subscribe{ _ in
                self.addPopUpView(category: GeneralCategoryEnum.mainCategory.rawValue, title: "הכנס קטגוריה", msg: "בחר שם:")
                UIView.animate(withDuration: 0.3, animations: {
                    if let pickerView = self.pikerView, let backgrondView = self.backgrondView {
                        pickerView.alpha = 0
                        backgrondView.alpha = 0
                    }
                })
            }.disposed(by: disposeBag)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemsCount.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.nameOfCategoryString = myArrayCategoryName[row] as String
        return myArrayCategoryName[row]
    }

    private func setupGeneralListTableViewCellWhenTapped() {
        tableUser.rx.itemSelected
            .subscribe(onNext: { indexPath in
    
        }).disposed(by: disposeBag)
    }
    
    func addObjectToVicationListFromGeneralList(item: [GroceryItem]){
        let alert = UIAlertController(title: item[0].key,
                                      message: "כמה פריטים צריך?",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "שמור", style: .default) { _ in
            guard let textField = alert.textFields?.first,
                let text = textField.text else { return }
            
            self.modelCell.addItemToNewList(path: TabCategoryEnum.temporaryCategory.rawValue, item: item,content: text)
        }
        
        let cancelAction = UIAlertAction(title: "ביטול",
                                         style: .cancel)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showPickerView(){
        if let pickerView = self.pikerView, let backgrondView = self.backgrondView {
            pickerView.alpha = 1
            backgrondView.alpha = 0.7
        }
    }
    
    func dismissPickerView(){
        if let pickerView = self.pikerView, let backgrondView = self.backgrondView{
            pickerView.alpha = 0
            backgrondView.alpha = 0
        }
    }
    
    func addPickerViewDelegate(){
        if let picker = self.picker{
            picker.delegate = self
            picker.dataSource = self
        }
    }
}
