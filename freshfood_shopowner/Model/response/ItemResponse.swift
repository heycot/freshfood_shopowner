//
//  ItemResponse.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/15/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

class ItemResponse :Decodable {
    var id: String?
    var name: String?
    var unit: String?
    
    init(id: String, name: String, unit: String) {
        self.id = id
        self.name = name
        self.unit = unit
    }
    
    convenience init() {
        self.init(id: "", name: "", unit: "")
    }
}
