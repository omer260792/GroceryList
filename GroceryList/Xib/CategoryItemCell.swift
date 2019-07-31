//
//  CategoryItemCell.swift
//  ShoppingList
//
//  Created by Omer Cohen on 6/14/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//
import Foundation
import RxCocoa
import RxSwift
import UIKit

class CategoryItemCell: UITableViewCell {
    
    @IBOutlet var isSendLabel: UILabel!
    @IBOutlet var imageViewItem: UIImageView!
    @IBOutlet var view: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var categoryStatusLabel: UILabel!
    @IBOutlet var categoryIsCompleted: UILabel!
    @IBOutlet var uidLabel: UILabel!
    @IBOutlet var secondCategroyLabel: UILabel!
    @IBOutlet var addPopupBtn: UIButton!
    @IBOutlet var viewCell: UIView!
    
    let disposeBag = DisposeBag()
    var delegate: GeneralListViewController!

    var num = 0
    var newNum = 0
    var stringTest = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()

       // populateSetupXib()
        addPopUp()
        populateViewTap()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func populateSetupXib() {
        
        if let catergoryStatus = categoryStatusLabel.text, let isCompleted = categoryIsCompleted.text{
            if isCompleted.isEmpty {
                if catergoryStatus.isEmpty{
                    print("isEmpty\(num + 1): ", catergoryStatus)
                }else{
                    print("isNoEmpty\(num + 1): ", catergoryStatus)
                    
                }
            }else{
                // disappear cell hieght equal 0
              //  self.view.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            }
          
        }
      
    }
    func populateViewTap() {
        let tapGesture = UITapGestureRecognizer()
        viewCell.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event.bind(onNext: { recognizer in
            
            var isSend:Bool
            var isColor:Bool
            var isDelete:String
            
            self.stringTest = self.secondCategroyLabel.text!
            let num = self.delegate.temporaryListViewModel.getCountTemporeryCtegorey()
            let newNum = String(num + 1)
            
            if let isSendBool = self.isSendLabel.text, let uid = self.uidLabel.text{
                if isSendBool == "false" {
                    isSend = true
                    isColor = true
                    isDelete = "false"
                    // save temporery list  core data
                    
                    if let title = self.titleLabel.text, let uid = self.uidLabel.text, let secondCategroy = self.secondCategroyLabel.text {
                        
                        self.delegate.addViewItemAmount.isHidden = false
                        self.delegate.addViewItemAmount.alpha = 1
                        self.delegate.backgroundView.alpha = 0.7
                        self.delegate.secondCategroyTitleTextTap = title
                        self.delegate.secondCategroyUIdTextTap = uid
                        self.delegate.secondCategroyTextTap = secondCategroy
                        self.delegate.secondCategroyIsSendTextTap = isSend
                    }

                }else{
                    // remove temporery list  core data
                    isSend = false
                    isColor = false
                    isDelete = "true"

                    let test = self.delegate.temporaryListViewModel.someEntityExists(uid: self.uidLabel.text!)
                    if test {
                        self.delegate.updateTemporeryObjectFromCoreData(uid: uid)
                    }else{
                        print("ssssdddd")
                    }
                    self.delegate.generaListViewModel.updateGeneralList(content: "", date: "", delete: isDelete, generalCategory: "", image: "", isColor: isColor, isCompleted: false , isSend: isSend, secondaryCategory: newNum, title: "", uid: uid, uidCategory:"", update: true)
                    
                    self.delegate.ReloadCategoryItemUpdateTableView()

                }
            }
        }).disposed(by: disposeBag)
    }
    
    func addPopUp() {
        addPopupBtn.rx.tap.subscribe {  _ in
          self.delegate.addPopupVactionView()
        }.disposed(by:self.disposeBag)
    }
}

