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
        
        let groceryItem = GroceryItem(name: item[0].name, content: content, date:TimeDataProvider.currentTimeInSecondsSting(), tabCategory: TabCategoryEnum.temporaryCategory.rawValue, generalCategory: GeneralCategoryEnum.mainCategory.rawValue, image: "", isSend: true, isColor: true, isCompleted: false, uid: item[0].uid)
                
        let groceryItemRef = refrence
        groceryItemRef.setValue(groceryItem.toAnyObject()){ (error, ref) -> Void in
            if error != nil {
                print("oops, an error")
            } else {
                self.updateAmountObject(pathString: TabCategoryEnum.generalCategory.rawValue, item: item, isColor: true)
            }
        }
        
    }
    
    func toggleContent(pathString: String) {
        let ref = Database.database().reference(withPath: pathString)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
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
                        ref.child(self.groceryItem!.key).updateChildValues(["isCompleted":isCompleted])
                    }
                }
            }
        })
    }
    
    func updateAmountObject(pathString: String,  item: [GroceryItem], isColor: Bool) {
        let ref = Database.database().reference(withPath: pathString)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    self.groceryItem = GroceryItem(snapshot: snap)
                    if self.groceryItem?.key == item[0].key {
                        ref.child(self.groceryItem!.key).updateChildValues(["isColor":isColor])
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
   
    
}
