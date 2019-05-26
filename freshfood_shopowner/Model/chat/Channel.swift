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
    var name: String
    var folder_image: String
    var users: [String]
    
    init(name: String, folder_image: String, users: [String]) {
        id = nil
        self.name = name
        self.folder_image = folder_image
        self.users = users
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let name = data["name"] as? String else {
            return nil
        }
        
        guard let folder_image = data["folder_image"] as? String else {
            return nil
        }
        
        guard let users = data["users"] as? [String] else {
            return nil
        }
        
        id = document.documentID
        self.name = name
        self.folder_image = folder_image
        self.users = users
    }
    
}

extension Channel: DatabaseRepresentation {
    
    var representation: [String : Any] {
        var rep = ["name": name]
        rep["folder_image"] = folder_image
        //        rep["users"] = users as Any
        
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
        return lhs.name < rhs.name
    }
    
}
