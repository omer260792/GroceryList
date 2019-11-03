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
    var arrowImagaeRotationAngle: CGFloat = CGFloat.pi * 0
    var photosCollectionViewController: PhotosCollectionViewController?
    let storage = Storage.storage(url:"gs://grocerylist-5c6ee.appspot.com")

    private var ref = Database.database()
    private var groceryItem:GroceryItem? = nil
    private let itemsEmpty: [GroceryItem] = []
    var collectionModel = PhotosCollectionViewController()
    static var modelCountToggleContent = ""


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
                self.updateColor(pathString: TabCategoryEnum.generalCategory.rawValue, item: item, isColor: true)
            }
        }
        
    }
    
    func toggleContent(pathString: String, name: String, isToggle: Bool) {
        let ref = Database.database().reference(withPath: pathString)
        ref.child(name).updateChildValues(["isCompleted":isToggle])
        ref.child(name).child("object").observeSingleEvent(of: .value, with: { (snapshot) in
        })
    }
    
  
    
    func addImgToFireStorge(pathString: String,  image: UIImage, itemName: String) {
        
        let storageRef = storage.reference()
        storageRef.child(pathString)
        // Data in memory
        if let data = image.pngData() {
            // Create a reference to the file you want to upload
            let riversRef = storageRef.child("\(pathString)/images/\("itemName").jpg")
            
            // Upload the file to the path "images/rivers.jpg"
            let uploadTask = riversRef.putData(data, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type.
                let size = metadata.size
                // You can also access to download URL after upload.
                riversRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                }
            }
        }
    }
    
    func updateAmountContent(pathString: String,  item: [GroceryItem], content: String, index: Int) {
        let ref = Database.database().reference(withPath: pathString)
        ref.child(item[index].key).updateChildValues(["content":content])

//        ref.child(itemNAME).observeSingleEvent(of: .value, with: { (snapshot) in
//            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
//                for snap in snapshots {
//                    self.groceryItem = GroceryItem(snapshot: snap)
//                    if self.groceryItem?.key == itemNAME {
//                    }
//                }
//            }
//        })
    }
    
    func updateColor(pathString: String,  item: [GroceryItem], isColor: Bool) {
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
                            self.updateColor(pathString: TabCategoryEnum.generalCategory.rawValue, item: [groc], isColor: false)
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
                            self.updateColor(pathString: TabCategoryEnum.generalCategory.rawValue, item: [groc], isColor: false)
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
    
    func downloadImage(pathString: String, name: String){
        let storageRef = storage.reference()
        var image : UIImage? = nil
        print("\(pathString)/images/\(name).jpg")
        let islandRef = storageRef.child("\(pathString)/images/\(name).jpg")
    
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
        if let error = error {
        } else {
        // Data for "images/island.jpg" is returned
            if let image = UIImage(data: data!){
                self.delegate!.showImageView(image: image)

            }
        }
        }
    }
    
    func scrollToTop(indexPath: IndexPath) {
        self.delegate?.tableUser.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func scrollToBottom(indexPath: IndexPath) {
        self.delegate?.tableUser.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }

}
