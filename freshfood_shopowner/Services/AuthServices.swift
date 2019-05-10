//
//  AuthServices.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/8/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import Firebase
import FirebaseFirestore

class AuthServices {
    static let instance = AuthServices()
    
    let defaults = Foundation.UserDefaults.standard
    var currentLocation : CLLocation? // = CLLocation(latitude: 16.056214, longitude:  108.217154)
    
    
    var isLoggedIn : Bool {
        get {
            return (Auth.auth().currentUser != nil)
        }
    }
    
    var userEmail : String {
        return (Auth.auth().currentUser?.email ?? "")
    }
    
    var authToken : String {
        return (Auth.auth().currentUser?.refreshToken ?? "")
    }
    
    func registerUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            // ...
        }

    }
}
