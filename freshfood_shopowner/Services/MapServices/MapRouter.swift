//
//  MapRouter.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/8/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

import Alamofire
import ObjectMapper

enum MapRouter: URLRequestConvertible {
    case directions(origin: String, destination: String)
    
    func asURLRequest() throws -> URLRequest {
        
        let result: (path: String, method: HTTPMethod, parameters: Parameters) = {
            switch self {
            case .directions(let origin, let destination):
                let requestBody = MapRequestBodyDirections(origin: origin, destination: destination)
                return ("directions/json", .get, requestBody.toJSON())
            }
        }()
        
        var url: URL!
        url = try! "https://maps.googleapis.com/maps/api".asURL()
        url = url.appendingPathComponent(result.path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = result.method.rawValue
        urlRequest.timeoutInterval = TimeInterval(10 * 1000)
        
        return try Alamofire.URLEncoding.default.encode(urlRequest, with: result.parameters)
    }
}
