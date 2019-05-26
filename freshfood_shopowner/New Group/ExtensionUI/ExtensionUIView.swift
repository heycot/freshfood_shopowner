//
//  ExtensionUIView.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/28/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

extension UIView {
    func setButtomBorderRadious() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 5.0
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
    }
    
    func setBorder(with color: UIColor) {
        self.layer.borderWidth = 1
        
        self.layer.borderColor = color.cgColor
    }
    
    func setBottomBorder(color: UIColor) {
        
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func setBorderRadious(radious: CGFloat) {
        self.layer.cornerRadius = radious
        self.layer.masksToBounds = true
    }
}

extension UIColor {
    
    convenience init(hex: Int, alpha: Double = 1.0) {
        
        self.init(red: CGFloat((hex>>16)&0xFF)/255.0, green:CGFloat((hex>>8)&0xFF)/255.0, blue: CGFloat((hex)&0xFF)/255.0, alpha:  CGFloat(255 * alpha) / 255)
    }
    
    static var primary: UIColor {
        return UIColor(red: 1 / 255, green: 93 / 255, blue: 48 / 255, alpha: 1)
    }
    
    static var incomingMessage: UIColor {
        return UIColor(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1)
    }
}

extension UIView {
    
    func smoothRoundCorners(to radius: CGFloat) {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: radius
            ).cgPath
        
        layer.mask = maskLayer
    }
    
}
