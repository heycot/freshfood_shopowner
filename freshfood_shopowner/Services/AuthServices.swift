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
    
    func signup(email: String, password: String, completion: @escaping (Bool?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let err = error {
                print(err.localizedDescription)
            }
            else{
                let userProfile = ["name": email,
                                   "email": password] as [String : Any]
                
                let db = Firestore.firestore()
                db.collection("user_profile").document(authResult!.user.uid).setData(userProfile) { err in
                    var result = true
                    if let err = err {
                        result = false
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                        //Đoạn này em có thể lưu user profile vào user default rồi nhảy tiếp qua home screen
                        //Ở bước này thì em có thể lưu user email, user name, user avatar. Hết. Ko đc lưu mật khẩu nha
                    }
                    
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }
                
            }
        }
    }
    
    
}
