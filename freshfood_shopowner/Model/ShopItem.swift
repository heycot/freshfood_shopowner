//
//  ShopItem.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/27/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

public class ShopItem {
    var id: Int
    var shop_id: Int
    var item_id: Int
    var price: Int
    var rating: Double
    var status: Int
    
    init(id: Int, shop_id: Int, item_id: Int, price: Int, rating: Double, status: Int ) {
        self.id = id
        self.shop_id = shop_id
        self.item_id = item_id
        self.price = price
        self.rating = rating
        self.status = status
    }
    
    convenience init() {
        self.init(id: 0, shop_id: 0, item_id: 0, price: 0, rating: 0.0, status: 0)
    }
}
