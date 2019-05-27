//
//  Channel.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/26/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import FirebaseFirestore


struct Channel : Decodable{
    
    var id: String?
    var is_with_shop: Int
    var name_first: String
    var image_first: String
    var user_id_first: String
    var name_second: String
    var image_second: String
    var user_id_second: String
    var users : [String]
    
    init(is_with_shop: Int, name_first: String, image_first: String, user_id_first: String,name_second: String, image_second: String, user_id_second: String, users: [String]) {
        id = nil
        self.is_with_shop = is_with_shop
        self.name_first = name_first
        self.image_first = image_first
        self.user_id_first = user_id_first
        self.name_second = name_second
        self.image_second = image_second
        self.user_id_second = user_id_second
        self.users = users
    }
    
    init() {
        self.init(is_with_shop: 1, name_first: "", image_first: "", user_id_first: "", name_second: "", image_second: "", user_id_second: "", users: [])
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let is_with_shop = data["is_with_shop"] as? Int else {
            return nil
        }
        
        guard let name_first = data["name_first"] as? String else {
            return nil
        }
        
        guard let image_first = data["image_first"] as? String else {
            return nil
        }
        
        guard let user_id_first = data["user_id_first"] as? String else {
            return nil
        }
        
        guard let name_second = data["name_second"] as? String else {
            return nil
        }
        
        guard let image_second = data["image_second"] as? String else {
            return nil
        }
        
        guard let user_id_second = data["user_id_second"] as? String else {
            return nil
        }
        
        guard let users = data["users"] as? [String] else {
            return nil
        }
        
        id = document.documentID
        self.is_with_shop = is_with_shop
        self.name_first = name_first
        self.image_first = image_first
        self.user_id_first = user_id_first
        self.name_second = name_second
        self.image_second = image_second
        self.user_id_second = user_id_second
        self.users = users
    }
    
}

extension Channel: DatabaseRepresentation {
    
    var representation: [String : Any] {
        var rep = ["name_first": name_first]
        //        rep["users"] = users
        
        if let id = id {
            rep["id"] = id
        }
        
        return rep
    }
    
}

extension Channel: Comparable {
    
    static func == (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.name_first < rhs.name_first || lhs.name_second < rhs.name_second
    }
    
}
