//
//  Favorites.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/27/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

public class favorites {
    var id: Int
    var user_id: Int
    var shopItem_id: Int
    
    init(id: Int, user_id: Int, shopItem_id: Int) {
        self.id = id
        self.user_id = user_id
        self.shopItem_id = shopItem_id
    }
    
    convenience init() {
        self.init(id: 0, user_id: 0, shopItem_id: 0)
    }
}
