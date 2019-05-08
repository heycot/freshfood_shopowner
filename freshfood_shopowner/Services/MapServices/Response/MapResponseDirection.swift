//
//  MapResponseDirections.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/17/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Alamofire
import ObjectMapper
import CoreLocation

class MapBaseResponse : Mappable {
    var status: String = ""
    required init?(map: Map) {}
    func mapping(map: Map) {
        status <- map["status"]
    }
}

class MapResponseDirections : MapBaseResponse {
    var geocoded_waypoints: Any?
    var routes: [MapResponseRoute]?
    required init?(map: Map) {
        super.init(map: map)
    }
    override func mapping(map: Map) {
        super.mapping(map: map)
        geocoded_waypoints <- map["geocoded_waypoints"]
        routes <- map["routes"]
    }
}

class MapResponseRoute : Mappable {
    var bounds: Any?
    var legs: [MapResponseLeg]?
    var overviewPolyline: MapResponseOverviewPolyline?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        bounds <- map["bounds"]
        legs <- map["legs"]
        overviewPolyline <- map["overview_polyline"]
    }
}

class MapResponseLeg : Mappable {
    var start_location: MapResponseLocation?
    var end_location: MapResponseLocation?
    var start_address: String?
    var end_address: String?
    var distance: MapResponseValueText?
    var duration: MapResponseValueText?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        start_location <- map["start_location"]
        end_location <- map["end_location"]
        start_address <- map["start_address"]
        end_address <- map["end_address"]
        distance <- map["distance"]
        duration <- map["duration"]
    }
}

class MapResponseLocation : Mappable {
    var lat: Double?
    var lng: Double?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        lat <- map["lat"]
        lng <- map["lng"]
    }
    
    func locationCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(lat ?? 0, lng ?? 0)
    }
}

class MapResponseValueText : Mappable {
    var value: UInt?
    var text: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        value <- map["value"]
        text <- map["text"]
    }
}

class MapResponseOverviewPolyline : Mappable {
    var points: String = ""
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        points <- map["points"]
    }
}
