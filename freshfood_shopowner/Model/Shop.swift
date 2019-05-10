//
//  Shop.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/27/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import Firebase

public class Shop {
    var id: String
    var name: String
    var rating: Double
    var time_open: String
    var time_close: String
    var create_date: TimeInterval
    var phone: String
    var location: GeoPoint
    var avatar: String
    var user_id: Int
    var status: Int
    
  
    init(id: String, name: String, rating: Double, time_open: String, time_close: String, create_date: TimeInterval, phone: String, location: GeoPoint, avatar: String, user_id: Int, status: Int) {
        self.id = id
        self.name = name
        self.rating = rating
        self.time_open = time_open
        self.time_close = time_close
        self.create_date = create_date
        self.phone = phone
        self.location = location
        self.avatar = avatar
        self.user_id = user_id
        self.status = status
    }
    
    convenience init() {
        self.init(id: "", name: "", rating: 0.0, time_open: "07:00 AM", time_close: "07:00 PM", create_date: Date().timeIntervalSince1970, phone: "", location:GeoPoint(latitude: 0, longitude: 0), avatar: "", user_id: 0, status: 0)
    }
}
