//
//  mapRequestBodyDirections.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/17/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import ObjectMapper

class MapRequestBodyDirections: Mappable {
    var origin:String!
    var destination: String!
    var key: String!
    
    required init?(map: Map) {}
    
    init(origin: String, destination: String) {
        self.origin = origin
        self.destination = destination
        //        self.key = GOOGLE_API_KEY
        self.key = DIRECTION_API_KEY
    }
    
    func mapping(map: Map) {
        origin <- map["origin"]
        destination <- map["destination"]
        key <- map["key"]
    }
}
