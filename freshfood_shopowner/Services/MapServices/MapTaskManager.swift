//
//  MapTaskManager.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/8/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Alamofire
import ObjectMapper

class MapTaskManager: SessionManager {
    
    static let sharedInstance = MapTaskManager()
    
    init() {
        super.init()
        self.session.configuration.httpMaximumConnectionsPerHost = 10
        self.session.configuration.timeoutIntervalForRequest = 20
    }
    
    /// Generic function to make request with Alamofire manager.
    ///
    /// - Parameters:
    ///   - urlRequest: The URL request
    ///   - domain: Error Domain
    ///   - success: <#success description#>
    ///   - failed: <#failed description#>
    func request(_ urlRequest: URLRequestConvertible,
                 success:@escaping (_ response: Any?) -> (),
                 failed:@escaping (_ error:NSError?) -> ()) {
        
        self.request(urlRequest).responseJSON { response in
            
            switch response.result {
            case .success:
                
                let responseResult = Mapper<MapBaseResponse>().map(JSONObject: response.result.value)
                if let resultCode = responseResult?.status {
                    if resultCode == "OK" {
                        success(response.result.value)
                    }
                    else {
                        failed(response.result.error as NSError?)
                    }
                }
                else {
                    failed(response.result.error as NSError?)
                }
                
            case .failure(let error):
                failed(error as NSError)
            }
        }
    }
}
