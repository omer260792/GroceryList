//
//  lineView.swift
//  GroceryList
//
//  Created by Omer Cohen on 8/15/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//

import UIKit

class lineView: UIView {

    weak var shapeLayer: CAShapeLayer?

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
    
    override func didChangeValue(forKey key: String) {
        if key != "decrease"{
            animateIncrease(key: key)
        }else{
            animateDecrease()
        }
    }
    
    func animateDecrease(){
        
        self.shapeLayer?.removeFromSuperlayer()
        
        // create whatever path you want
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 3))
        path.addLine(to: CGPoint(x: 0, y: 3))
        
        // create shape layer for that path
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        shapeLayer.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        shapeLayer.lineWidth = 0
        shapeLayer.path = path.cgPath
        
        // animate it
        self.layer.addSublayer(shapeLayer)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 1.5
        shapeLayer.add(animation, forKey: "MyAnimation")
        
        // save shape layer
        self.shapeLayer = shapeLayer
    }
    
    func animateIncrease(key: String){
        
        self.shapeLayer?.removeFromSuperlayer()
        let fl: CGFloat = CGFloat((key as NSString).doubleValue)

        // create whatever path you want
        let path = UIBezierPath()

        path.move(to: CGPoint(x: 275 - fl, y: 3))
//        path.addLine(to: CGPoint(x: 230, y: 3))
        path.addLine(to: CGPoint(x: 280, y: 3))

        
        // create shape layer for that path
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        shapeLayer.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.path = path.cgPath
        
        // animate it
        self.layer.addSublayer(shapeLayer)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 0.5
        shapeLayer.add(animation, forKey: "MyAnimation")
        
        // save shape layer
        self.shapeLayer = shapeLayer
    }
    
    
}
