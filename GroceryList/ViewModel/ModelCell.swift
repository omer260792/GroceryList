//
//  modelCell.swift
//  GroceryList
//
//  Created by Omer Cohen on 7/31/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Firebase

class ModelCell: UITableViewCell {
    
    let disposeBag = DisposeBag()
    var delegate: GeneralListViewController?
    var viewModel: GeneralListCellViewModel?
    var vicationViewModel: VicationViewModel?
    var items: [GroceryItem] = []
    var arrayNamePicker = [String]()

    private var ref = Database.database()
    private var groceryItem:GroceryItem? = nil
    private let itemsEmpty: [GroceryItem] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupView() {}
    func fillCellData(){}
    
    func addItemToNewList(path: String, item: [GroceryItem], content: String){
        let refrence = Database.database().reference(withPath: path).child(item[0].key)
        
        let groceryItem = GroceryItem(name: item[0].name, content: content, date:TimeDataProvider.currentTimeInSecondsSting(), tabCategory: TabCategoryEnum.temporaryCategory.rawValue, generalCategory: GeneralCategoryEnum.secondCategory.rawValue, image: "", isSend: true, isColor: true, isCompleted: false, uid: item[0].uid)
                
        let groceryItemRef = refrence
        groceryItemRef.setValue(groceryItem.toAnyObject()){ (error, ref) -> Void in
            if error != nil {
                print("oops, an error")
            } else {
                self.updateAmountObject(pathString: TabCategoryEnum.generalCategory.rawValue, item: item, isColor: true)
            }
        }
        
    }
    
    func toggleContent(pathString: String, name: String) {
        let ref = Database.database().reference(withPath: pathString)
        ref.child(name).child("object").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    self.groceryItem = GroceryItem(snapshot: snap)
                    if self.groceryItem?.name == self.items[0].name {
                        var isCompleted: Bool
                        if self.items[0].isCompleted == true{
                            isCompleted = false
                        }else{
                            isCompleted = true
                        }
                       ref.child(name).updateChildValues(["isCompleted":isCompleted])
                        ref.child(name).child("object").child(self.groceryItem!.key).updateChildValues(["isCompleted":isCompleted])
                    }
                }
            }
        })
    }
    
    func updateAmountObject(pathString: String,  item: [GroceryItem], isColor: Bool) {
        let ref = Database.database().reference(withPath: pathString)
        ref.child(item[0].name).child("object").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    self.groceryItem = GroceryItem(snapshot: snap)
                    if self.groceryItem?.key == item[0].key {
                        ref.child(item[0].name).child("object").child(self.groceryItem!.key).updateChildValues(["isColor":isColor])
                    }
                }
            }
        })
    }
    
    func getVicationCategoryToPickerview(pathString: String) -> [GroceryItem]{
        var itemsCount: [GroceryItem] = []
        let ref = Database.database().reference(withPath: pathString)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    self.groceryItem = GroceryItem(snapshot: snap)
                    if let groc = self.groceryItem{
                        if groc.generalCategory == GeneralCategoryEnum.mainCategory.rawValue{
                            itemsCount = [self.groceryItem] as! [GroceryItem]
                        }
                    }
                }
            }
        })
        return itemsCount
    }
    
    func removeTemporaryList(pathString: String) {
        let ref = Database.database().reference(withPath: pathString)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    self.groceryItem = GroceryItem(snapshot: snap)
                    if let groc = self.groceryItem{
                        if groc.isCompleted == true{
                            self.updateAmountObject(pathString: TabCategoryEnum.generalCategory.rawValue, item: [groc], isColor: false)
                            groc.ref?.removeValue()
                        }
                    }
                }
            }
        })
    }
    
    func updateGeneralListAndVicationListNameCategory(pathString: String, indexPath: IndexPath, item: [GroceryItem]) {
        let key = "כללי"
        var num = 0
        var itemNewIndex = 0
        var ref = Database.database().reference(withPath: pathString)
        print(item[0].key)
        ref.child(item[0].key).child("object").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                var uid = key
                for snap in snapshots {
                    self.groceryItem = GroceryItem(snapshot: snap)
                    if let groc = self.groceryItem{
                        if groc.name == item[indexPath.row].key{
                            
                            uid = key + " " + GeneralCategoryEnum.secondCategory.rawValue

        
                            if num == 0{
                                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                                    
                                    if !snapshot.hasChild(key){
                                        
                                        self.SaveGroceryObjectFireBase(key: key, pathString: GeneralCategoryEnum.mainCategory.rawValue, tabCategory: pathString, ref: ref, indexPath: indexPath)
                                    }
                                    
                                    num = 1
                                    
                                })
                                
                            }
                            let item = GroceryItem(name: key, content: groc.content, date: TimeDataProvider.currentTimeInSecondsSting(), tabCategory: groc.tabCategory, generalCategory: groc.generalCategory, image: groc.image, isSend: false, isColor: false, isCompleted: false, uid: key+groc.generalCategory)
                            
                            let groceryItemRef = ref.child(key).child("object").child(groc.key)
                            
                            groceryItemRef.setValue(item.toAnyObject()){ (error, ref) -> Void in
                                
                                if error != nil {
                                    print("oops, an error")
                                } else {
                                    print("completed")
                                }
                            }
                        }
                    }
                }
            }
        })
    }
    
    func SaveGroceryObjectFireBase(key: String, pathString: String, tabCategory: String, ref: DatabaseReference, indexPath: IndexPath){

        let groceryItem = GroceryItem(name: key, content: "", date: TimeDataProvider.currentTimeInSecondsSting(), tabCategory: tabCategory, generalCategory: pathString, image: "", isSend: false, isColor: false, isCompleted: false, uid: key)
        
        let groceryItemRef = ref.child(key)
        print("hg",groceryItemRef)

        groceryItemRef.setValue(groceryItem.toAnyObject()){ (error, ref) -> Void in
            
            if error != nil {
                print("oops, an error")
            } else {
                print("completed")
            }
        }
    }
    
    func updateGeneralListCellColor(pathString: String, grocObjKey: String, name: String) {
        let ref = Database.database().reference(withPath: pathString)
        ref.child(name).child("object").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    self.groceryItem = GroceryItem(snapshot: snap)
                    if let groc = self.groceryItem{
                        if groc.key == grocObjKey{
                            self.updateAmountObject(pathString: TabCategoryEnum.generalCategory.rawValue, item: [groc], isColor: false)
                        }
                    }
                }
            }
        })
    }
    
    func ifAllListExsits(ref: DatabaseReference) -> Int {
        return 0
    }
    
    func toggleLine(pathString: String) {
        let ref = Database.database().reference(withPath: pathString)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    self.groceryItem = GroceryItem(snapshot: snap)
                    if self.groceryItem?.key == self.items[0].key {
                        var isCompleted: Bool
                        if self.items[0].isCompleted == true{
                            isCompleted = false
                        }else{
                            isCompleted = true
                        }
                        ref.child(self.groceryItem!.key).updateChildValues(["isCompleted":isCompleted])
                    }
                }
            }
        })
    }
    
    func markCheckBox(pathString: String, name: String) -> Bool {
        var isSend: Bool = false
        let ref = Database.database().reference(withPath: pathString)
        ref.child(name).child("object").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    self.groceryItem = GroceryItem(snapshot: snap)
                    if self.groceryItem?.key == self.items[0].key {
                        if self.items[0].isSend == true{
                            isSend = false
                        }else{
                            isSend = true
                        };                        ref.child(name).child("object").child(self.groceryItem!.key).updateChildValues(["isSend":isSend])
                    }
                }
            }
        })
        return isSend
    }
    
    func setAllMarkCheckboxEmpty(pathString: String, name: String) {
        let ref = Database.database().reference(withPath: pathString)
        ref.child(name).child("object").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    self.groceryItem = GroceryItem(snapshot: snap)
                    ref.child(name).child("object").child(self.groceryItem!.key).updateChildValues(["isSend":false])
                    
                }
            }
        })
    }

}
