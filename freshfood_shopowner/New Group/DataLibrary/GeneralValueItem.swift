//
//  GeneralValueItem.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/5/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation



class ItemValue {
    var icon :String?
    var value:String?
    
    init(icon: String, value: String) {
        self.icon = icon
        self.value = value
    }
    
    convenience init() {
        self.init(icon: "price-tag", value: "VND 70.000")
    }
}

