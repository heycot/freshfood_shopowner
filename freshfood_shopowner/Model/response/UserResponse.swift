//
//  UserResponse.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/23/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
class UserResponse:Decodable {
    
    var name: String?
    var email: String?
    var phone: String?
    var birthday: Double?
    var avatar: String?
    var address: String?
    var create_date: Double?
    var status: Int?
//    var shops: [ShopResponse]?
//    var comments: [CommentResponse]?
//    var favorites: [FavoritesResponse]?
    
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
    
    
    init( name: String, email: String, phone: String,  birthday: Date, avatar: String, address: String, create_date: Date, status: Int) {
    
        self.name = name
        self.email = email
        self.phone = phone
        self.birthday = birthday.timeIntervalSince1970
        self.avatar = avatar
        self.address = address
        self.create_date = create_date.timeIntervalSince1970
        self.status = status
    }
    
    convenience init() {
        self.init( name: "", email: "", phone: "",  birthday: Date(), avatar: "", address: "", create_date: Date(), status: 0)
    }
}
