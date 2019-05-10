//
//  ShopResponse.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/20/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase

struct ShopResponse: Decodable {
    var id: Int?
    var user_id: String?
    var name: String?
    var rating: Double?
    var time_open: String?
    var time_close: String?
    var create_date: TimeInterval?
    var status: Int?
    var phone: String?
    var avatar: String?
    var sell: String?
    var longitude: Double?
    var latitude: Double?
    var address: String?
    
    init(id: Int, user_id: String, name: String, rating: Double, time_open: String, time_close: String, create_date: TimeInterval, status: Int, phone: String, avatar: String, sell: String, longitude: Double, latitude: Double, address: String) {
        self.id = id
        self.user_id = user_id
        self.name = name
        self.rating = rating
        self.time_open = time_open
        self.time_close = time_close
        self.create_date = create_date
        self.status = status
        self.phone = phone
        self.avatar = avatar
        self.sell = sell
        self.longitude = longitude
        self.latitude = latitude
        self.address = address
    }
    
    init(){
        self.init(id: 0, user_id: "", name: "", rating: 0.0, time_open: "", time_close: "", create_date: NSDate().timeIntervalSince1970, status: 1, phone: "", avatar: "", sell: "",longitude: 0.0, latitude: 0.0, address: "")
    }
    
    init(name: String, longitude: Double, latitude: Double) {
        self.init()
        self.longitude = longitude
        self.latitude = latitude
        self.name = name
    }
    
    func getDistance(currlocation: CLLocation?) -> String {
        var distance =  ""
        if self.latitude == 0.0, self.longitude == 0.0 { return "Unknown" }
        guard let userLocation = currlocation else {  return "Unknown"  }
        
        let coordinate₀ = CLLocation(latitude: self.latitude ?? 0.0, longitude: self.longitude ?? 0.0)
        
        let distanceInMeters = coordinate₀.distance(from: userLocation)
        if distanceInMeters < 1000 {
            distance = String(format: " %.2f ", distanceInMeters) + " M"
        } else {
            distance = String(format: " %.2f ", distanceInMeters.inKilometers()) + " KM"
        }
        
        return distance
    }
}

extension CLLocationDistance {
    func inMiles() -> CLLocationDistance {
        return self*0.00062137
    }
    
    func inKilometers() -> CLLocationDistance {
        return self/1000
    }
}
