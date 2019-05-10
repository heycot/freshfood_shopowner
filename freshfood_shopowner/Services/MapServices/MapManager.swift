//
//  MapManager.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/8/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class Mapmanager {
    static func getDirections(_ origin: String, destination: String, success:@escaping (_ response: MapResponseDirections?) -> (),
                              failed:@escaping (_ error: NSError?) -> ()) {
        MapTaskManager.sharedInstance.request(MapRouter.directions(origin: origin, destination: destination), success: { (response) in
            success(Mapper<MapResponseDirections>().map(JSONObject: response))
        }) { (error) in
            failed(error)
        }
        
    }
}

