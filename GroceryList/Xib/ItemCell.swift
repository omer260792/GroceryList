//
//  ItemCell.swift
//  GroceryList
//
//  Created by Omer Cohen on 7/31/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit
import RxGesture

class ItemCell: ModelCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var lineView: lineView!
    @IBOutlet var viewCell: UIView!
    @IBOutlet var imageViewCell: UIImageView!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var showImagebtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        self.delegate = delegate
        self.collectionModel = collectionModel
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setListCell(model: GroceryItem){
        titleLabel.text = model.key
        contentLabel.text = model.content
        showImagebtn.isHidden = model.image == ""
    }
    
    override func setupView() {
        
        showImagebtn.rx.tap.subscribe{_ in
            print(self.lineView.tag)
            self.downloadImage(pathString: TabCategoryEnum.temporaryCategory.rawValue, name: self.items[0].key)
            
        }.disposed(by: self.disposeBag)
        
    }
    
    public func drawLine(item: GroceryItem){
        let titleWidth = titleLabel.intrinsicContentSize.width
        lineView.rx.base.isTapToDraw(width: titleWidth, isTap: item.isCompleted)
    }
    
    public func addLine(item: GroceryItem){
        let titleWidth = titleLabel.intrinsicContentSize.width
        lineView.rx.base.isTapAddLine(width: titleWidth, isTap: item.isCompleted)
    }
    
}

extension UILabel {
    func getSeparatedLines() -> [Any] {
        if self.lineBreakMode != NSLineBreakMode.byWordWrapping {
            self.lineBreakMode = .byWordWrapping
        }
        var lines = [Any]() /* capacity: 10 */
        let wordSeparators = CharacterSet.whitespacesAndNewlines
        var currentLine: String? = self.text
        let textLength: Int = (self.text?.count ?? 0)
        var rCurrentLine = NSRange(location: 0, length: textLength)
        var rWhitespace = NSRange(location: 0, length: 0)
        var rRemainingText = NSRange(location: 0, length: textLength)
        var done: Bool = false
        while !done {
            // determine the next whitespace word separator position
            rWhitespace.location = rWhitespace.location + rWhitespace.length
            rWhitespace.length = textLength - rWhitespace.location
            rWhitespace = (self.text! as NSString).rangeOfCharacter(from: wordSeparators, options: .caseInsensitive, range: rWhitespace)
            if rWhitespace.location == NSNotFound {
                rWhitespace.location = textLength
                done = true
            }
            let rTest = NSRange(location: rRemainingText.location, length: rWhitespace.location - rRemainingText.location)
            let textTest: String = (self.text! as NSString).substring(with: rTest)
            let fontAttributes: [String: Any]? = [NSAttributedString.Key.font.rawValue: font]
            let maxWidth = (textTest as NSString).size(withAttributes: [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font]).width
            if maxWidth > self.bounds.size.width {
                lines.append(currentLine?.trimmingCharacters(in: wordSeparators) ?? "")
                rRemainingText.location = rCurrentLine.location + rCurrentLine.length
                rRemainingText.length = textLength - rRemainingText.location
                continue
            }
            rCurrentLine = rTest
            currentLine = textTest
        }
        lines.append(currentLine?.trimmingCharacters(in: wordSeparators) ?? "")
        return lines
    }
    
    var lastLineWidth: CGFloat {
        let lines: [Any] = self.getSeparatedLines()
        if !lines.isEmpty {
            let lastLine: String = (lines.last as? String)!
            let fontAttributes = [NSAttributedString.Key.font.rawValue: font]
            return (lastLine as NSString).size(withAttributes: [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font]).width
        }
        return 0
    }
    
    
    
    
    
}
