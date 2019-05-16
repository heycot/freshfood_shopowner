//
//  UserResponse.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/23/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
class UserResponse:Decodable {
    var id: String?
    var name: String?
    var email: String?
    var phone: String?
    var birthday: TimeInterval?
    var avatar: String?
    var address: String?
    var create_date: TimeInterval?
    var status: Int?
    
    var birthdayDate: Date? {
        if let day = self.birthday {
            // from milisecond in Java to second in Swift with TimeInterval
            return Date(timeIntervalSince1970: day / 1000)
        }
        return nil
    }
    
    var createDate: Date? {
        if let day = self.create_date {
            return Date(timeIntervalSince1970: day / 1000)
        }
        return nil
    }
    
    
    init( id: String, name: String, email: String, phone: String,  birthday: TimeInterval, avatar: String, address: String, create_date: TimeInterval, status: Int) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.birthday = birthday
        self.avatar = avatar
        self.address = address
        self.create_date = create_date
        self.status = status
    }
    
    convenience init() {
        self.init( id: "", name: "", email: "", phone: "",  birthday: Date().timeIntervalSince1970, avatar: "", address: "", create_date: Date().timeIntervalSince1970, status: 0)
    }
}
