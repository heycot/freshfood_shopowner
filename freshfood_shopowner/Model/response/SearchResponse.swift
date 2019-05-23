//
//  SearchResponse.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/23/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

struct SearchResponse: Decodable, Hashable{
    var entity_id: String?
    var entity_name: String?
    var address: String?
    var is_shop: Int?
    var avatar: String?
    
    init( entity_id: String, entity_name: String, address: String, is_shop: Int, avatar: String) {
        self.entity_id = entity_id
        self.entity_name = entity_name
        self.address = address
        self.is_shop = is_shop
        self.avatar = avatar
    }
    
    init() {
        self.init(entity_id: "", entity_name: "", address: "", is_shop: 0, avatar: "")
    }
}
