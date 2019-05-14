//
//  CommentResponse.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/13/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation


class CommentResponse: Decodable {
    var id: String?
    var user_id: String?
    var shopitem_id: String?
    var title: String?
    var content: String?
    var create_date: TimeInterval?
    var rating: Double?
    
    var createDate: Date? {
        if let day = self.create_date {
            return Date(timeIntervalSince1970: day / 1000)
        }
        return nil
    }
    
    init(id: String, title: String, content: String, create_date: Date, rating: Double, user_id: String, shopitem_id: String) {
        self.id = id
        self.title = title
        self.content = content
        self.create_date = create_date.timeIntervalSince1970
        self.rating = rating
        self.user_id = user_id
        self.shopitem_id = shopitem_id
    }
    
    convenience init() {
        self.init(id: "", title: "", content: "", create_date: Date(), rating: 0.0, user_id: "", shopitem_id: "")
    }
}