//
//  ShopItemResponse.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/11/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

struct ShopItemResponse: Decodable{
    var id: String?
    var price: Double?
    var status: Int?
    var rating: Double?
    var comment_number: Int?
    var favorites_number: Int?
    var name: String?
    var shop_name: String?
    var avatar: String?
    var unit : String?
//    var location : GeoPoint
    
    // Constructor.
    init(id: String, price: Double, status: Int, rating: Double, comment_number: Int, favorites_number: Int, name: String, shop_name: String, avatar: String, unit : String) {
        self.id = id
        self.price = price
        self.status = status
        self.rating = rating
        self.comment_number = comment_number
        self.favorites_number = favorites_number
        self.name = name
        self.shop_name = shop_name
        self.avatar = avatar
        self.unit = unit
    }
    
    init() {
        self.init(id: "", price: 0.0, status: 1, rating: 0, comment_number: 0, favorites_number: 0, name: "", shop_name: "", avatar: "", unit: "")
    }
}
