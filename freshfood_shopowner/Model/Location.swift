//
//  Location.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/27/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation


public class Location {
    var id: Int
    var area_id: Int
    var name: String
    var address: String
    var longitude: Double
    var latitude: Double
    
    init(id: Int, area_id: Int, name: String, address: String, longitude: Double, latitude: Double) {
        self.id = id
        self.area_id = area_id
        self.name = name
        self.address = address
        self.longitude = longitude
        self.latitude = latitude
    }
    
    convenience init() {
        self.init(id: 0, area_id: 0, name: "", address: "", longitude: 0.0, latitude: 0.0)
    }
}
