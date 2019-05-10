//
//  Item.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/27/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

public class Item {
    var id: Int
    var name: String
    var catalog_id: Int
    
    init(id: Int, name: String, catalog_id: Int) {
        self.id = id
        self.name = name
        self.catalog_id = catalog_id
    }
    
    convenience init() {
        self.init(id: 0, name: "", catalog_id: 0)
    }
}
