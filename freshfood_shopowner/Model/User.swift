//
//  User.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/27/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

public class User: NSObject, NSCoding{
    
    var id: Int!
    var name: String!
    var email: String!
    var phone: String!
    var password: String!
    var birthday: Date!
    var avatar: String!
    var address: String!
    var create_date: Date!
    var status: Int!
    var token: String!
    
    
    init(id: Int, name: String, email: String, phone: String, password: String, birthday: Date, avatar: String, address: String, create_date: Date, status: Int, token: String) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.password = password
        self.birthday = birthday
        self.avatar = avatar
        self.address = address
        self.create_date = create_date
        self.status = status
        self.token = token
    }
    
    convenience override init() {
        self.init(id: 0, name: "", email: "", phone: "", password: "", birthday: Date(), avatar: "", address: "", create_date: Date(), status: 0, token: "")
    }

    required convenience public init(coder decoder: NSCoder) {
        self.init()
        self.id = decoder.decodeObject(forKey: "id") as? Int
        self.name = decoder.decodeObject(forKey: "name") as? String
        self.email = decoder.decodeObject(forKey: "email") as? String
        self.phone = decoder.decodeObject(forKey: "phone") as? String
        self.password = decoder.decodeObject(forKey: "password") as? String
        self.birthday = decoder.decodeObject(forKey: "birthday") as? Date
        self.avatar = decoder.decodeObject(forKey: "avatar") as? String
        self.address = decoder.decodeObject(forKey: "address") as? String
        self.create_date = decoder.decodeObject(forKey: "create_date") as? Date
        self.status = decoder.decodeObject(forKey: "status") as? Int
        self.token = decoder.decodeObject(forKey: "token") as? String
    }
    
    public func encode(with coder: NSCoder) {
        if let id = id { coder.encode(id, forKey: "id") }
        if let name = name { coder.encode(name, forKey: "name") }
        if let email = email { coder.encode(email, forKey: "email") }
        if let phone = phone { coder.encode(phone, forKey: "phone") }
        if let password = password { coder.encode(password, forKey: "password") }
        if let birthday = birthday { coder.encode(birthday, forKey: "birthday") }
        if let avatar = avatar { coder.encode(avatar, forKey: "avatar") }
        if let address = address { coder.encode(address, forKey: "address") }
        if let create_date = create_date { coder.encode(create_date, forKey: "create_date") }
        if let status = status { coder.encode(status, forKey: "status") }
        if let token = token { coder.encode(token, forKey: "token") }
    }
    
}
