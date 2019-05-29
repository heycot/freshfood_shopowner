//
//  ExtensionButton.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/26/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

extension UIButton {
    func setBorderRadous(color: UIColor) {
        self.backgroundColor = .clear
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
    }
    
    func boderRadiousWithoutCollor() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}


