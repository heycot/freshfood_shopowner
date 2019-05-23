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

struct ShopResponse: Decodable, Hashable {
    var oldid: Int?
    var id: String?
    var user_id: String?
    var name: String?
    var rating: Double?
    var comment_number: Int?
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
    var keyword: [String]?
    
    var distance: Double? {
        if (AuthServices.instance.currentLocation != nil) {
            let coordinate₀ = CLLocation(latitude: self.latitude ?? 0.0, longitude: self.longitude ?? 0.0)
            return coordinate₀.distance(from: AuthServices.instance.currentLocation!)
        }
        return nil
    }
    
    init(id: String, user_id: String, name: String, rating: Double, time_open: String, time_close: String, create_date: TimeInterval, status: Int, phone: String, avatar: String, sell: String, longitude: Double, latitude: Double, address: String, keyword: [String]) {
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
        self.keyword = keyword
    }
    
    init(){
        self.init(id: "", user_id: "", name: "", rating: 0.0, time_open: "", time_close: "", create_date: NSDate().timeIntervalSince1970, status: 1, phone: "", avatar: "", sell: "",longitude: 0.0, latitude: 0.0, address: "", keyword: [String]())
    }
    
    init(id: String, name: String) {
        self.init()
        self.id = id
        self.name = name
    }
    
    init(name: String, longitude: Double, latitude: Double) {
        self.init()
        self.longitude = longitude
        self.latitude = latitude
        self.name = name
    }
    
    init(name: String, address: String, longitude: Double, latitude: Double) {
        self.init()
        self.longitude = longitude
        self.latitude = latitude
        self.name = name
        self.address = address
    }
    
    init(id: String, name: String, address: String, longitude: Double, latitude: Double) {
        self.init()
        self.id = id
        self.longitude = longitude
        self.latitude = latitude
        self.name = name
        self.address = address
    }
    
    init(id: String, name: String, address: String, longitude: Double, latitude: Double, time_open: String, time_close: String) {
        self.init()
        self.id = id
        self.longitude = longitude
        self.latitude = latitude
        self.name = name
        self.address = address
        self.time_open = time_open
        self.time_close = time_close
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
    
    func convertToSearchResponse() -> SearchResponse {
        var search = SearchResponse()
        
        search.is_shop = 1
        search.entity_id = self.id
        search.address = self.address
        search.entity_name = self.name
        search.avatar = self.avatar
        
        return search
    }}

extension CLLocationDistance {
    func inMiles() -> CLLocationDistance {
        return self*0.00062137
    }
    
    func inKilometers() -> CLLocationDistance {
        return self/1000
    }
}
