//
//  lineView.swift
//  GroceryList
//
//  Created by Omer Cohen on 8/15/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//

import UIKit

class lineView: UIView {

    let maskLayer = CAShapeLayer()
    var rectanglePath = UIBezierPath()
    
    override func addSubview(_ view: UIView) {
        animation(num: 0)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        animation(num: 0)

//        backgroundColor = UIColor.clear
//
//        // initial shape of the view
//        rectanglePath = UIBezierPath(rect: bounds)
//
//        // Create initial shape of the view
//        shapeLayer.path = rectanglePath.cgPath
//        shapeLayer.strokeColor = UIColor.black.cgColor
//        shapeLayer.fillColor = UIColor.clear.cgColor
//        layer.addSublayer(shapeLayer)
//
//        //mask layer
//        maskLayer.path = shapeLayer.path
//        maskLayer.position =  shapeLayer.position
//        layer.mask = maskLayer
    }
    
//    func prepareForEditing(editing:Bool){
//
//        let animation = CABasicAnimation(keyPath: "path")
//        animation.duration = 2
//
//        // Your new shape here
//        animation.toValue = UIBezierPath(ovalIn: bounds).cgPath
//        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
//
//        // The next two line preserves the final shape of animation,
//        // if you remove it the shape will return to the original shape after the animation finished
//        animation.fillMode = CAMediaTimingFillMode.forwards
//        animation.isRemovedOnCompletion = false
//
//        shapeLayer.add(animation, forKey: nil)
//        maskLayer.add(animation, forKey: nil)
//    }
    
    func animation(num: Int){
       
        CATransaction.begin()
        
        let layer : CAShapeLayer = CAShapeLayer()
        layer.strokeColor = UIColor.purple.cgColor
        layer.lineWidth = 1.0
        layer.fillColor = UIColor.clear.cgColor
        
        let path : UIBezierPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.frame.size.width + 2, height: self.frame.size.height + 2), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 5.0, height: 0.0))
        layer.path = path.cgPath
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 0.5
        
        animation.duration = 2.0
        
        CATransaction.setCompletionBlock{ [weak self] in
            print("Animation completed")
        }
        
        layer.add(animation, forKey: "myStroke")
        CATransaction.commit()
        self.layer.addSublayer(layer)
    }
    
    
}
