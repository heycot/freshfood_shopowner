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
    
    
    func signup(name: String, email: String, password: String, completion: @escaping (Bool?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let err = error {
                print(err.localizedDescription)
            }
            else{
                let date = Date().timeIntervalSince1970
                let userProfile = ["name": name,
                                   "email": email,
                                   "phone": "",
                                   "birthday": 0,
                                   "create_date": date,
                                   "address": "" ] as [String : Any]
                
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
    
    func signin(email: String, password: String, completion: @escaping (Bool?) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            
            if error != nil {
                DispatchQueue.main.async {
                    completion(false)
                }
            } else {
                if let user = authResult?.user {
                    let uid = user.uid
                    
                    //Truy cập vào user_profile để lấy user profile với uid
                    let db = Firestore.firestore()
                    let docRef = db.collection("user_profile").document(uid)
                    
                    docRef.getDocument(completion: { (document, error) in
                        if let document = document, document.exists {
//                            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//
//                            print("Document data: \(dataDescription)")
//                            print(document.data())
//                            //Đoạn này em maping cái profile thành User object của em nha, hoặc lưu vào
                            //em thử map Data vào như em làm bên app kia coi có đc ko:
                            let jsonData = try? JSONSerialization.data(withJSONObject: document.data() as Any)
                            do {
                                _ = try JSONDecoder().decode(UserResponse.self, from: jsonData!)
                            } catch let jsonError {
                                print("Error serializing json:", jsonError)
                            }
                            
                            DispatchQueue.main.async {
                                completion(true)
                            }
                        } else {
                            print("User have no profile")
                        }
                    })
                }
            }
        }
    }
    
    
    func getProfile(completion: @escaping (UserResponse?) -> Void){
        let userID = Auth.auth().currentUser!.uid
        
        let db = Firestore.firestore()
        let docRef = db.collection("user_profile").document(userID)
        
        docRef.getDocument(completion: { (document, error) in
            if let document = document, document.exists {
                let jsonData = try? JSONSerialization.data(withJSONObject: document.data() as Any)
                do {
                    let user = try JSONDecoder().decode(UserResponse.self, from: jsonData!)
                    user.id = document.documentID
                    
                    DispatchQueue.main.async {
                        completion(user)
                    }
                } catch let jsonError {
                    print("Error serializing json:", jsonError)
                }
                
            } else {
                print("User have no profile")
            }
        })
    }
}
