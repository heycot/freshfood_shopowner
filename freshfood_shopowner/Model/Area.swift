//
//  Area.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/27/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

public class Area {
    var id: Int
    var city_id: Int
    var name: String
    
    init(id: Int, name: String, city_id: Int) {
        self.id = id
        self.name = name
        self.city_id = city_id
    }
    
    convenience init() {
        self.init(id: 0, name: "", city_id: 0)
    }
    
}
