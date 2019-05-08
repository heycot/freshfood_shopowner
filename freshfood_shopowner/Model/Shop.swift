//
//  Shop.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/27/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

public class Shop {
    var id: Int
    var name: String
    var rating: Double
    var time_open: Date
    var time_close: Date
    var create_date: Date
    var phone: String
    var location_id: Int
    var avatar: String
    var user_id: Int
    var status: Int
    
    init(id: Int, name: String, rating: Double, time_open: Date, time_close: Date, create_date: Date, phone: String, location_id: Int, avatar: String, user_id: Int, status: Int) {
        self.id = id
        self.name = name
        self.rating = rating
        self.time_open = time_open
        self.time_close = time_close
        self.create_date = create_date
        self.phone = phone
        self.location_id = location_id
        self.avatar = avatar
        self.user_id = user_id
        self.status = status
    }
    
    convenience init() {
        self.init(id: 0, name: "", rating: 0.0, time_open: Date(), time_close: Date(), create_date: Date(), phone: "", location_id: 0, avatar: "", user_id: 0, status: 0)
    }
}
