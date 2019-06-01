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
    
    var user: UserResponse?
    
    func signup(name: String, email: String, password: String, avatar: String, completion: @escaping (Bool?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let err = error {
                print(err.localizedDescription)
            }
            else{
                let date = Date().timeIntervalSince1970
                
                
                let emails = email.split(separator: "@")
                
                var keywords = String.gennerateKeywordsMod(name: name , address: "")
                keywords.append(email.lowercased())
                keywords.append(emails[0].lowercased())
                
                
                let userProfile = ["name": name,
                                   "email": email,
                                   "phone": "",
                                   "birthday": 0,
                                   "create_date": date,
                                   "address": "" ,
                                   "keywords": keywords,
                                   "avatar": avatar] as [String : Any]
                
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
                                let user = try JSONDecoder().decode(UserResponse.self, from: jsonData!)
                                self?.user = user
                                self?.user?.id = document.documentID
                                
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
    
    func signout() {
        self.user = nil
        try! Auth.auth().signOut()
    }
    
    func getProfile(userID: String, completion: @escaping (UserResponse?) -> Void){
        
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
    
    
    func edit(user: UserResponse, completion: @escaping (Bool?) -> Void){
        let userID = Auth.auth().currentUser!.uid
        self.user = user
        
        let db = Firestore.firestore()
        
        let emails = user.email!.split(separator: "@")
        
        var keywords = String.gennerateKeywordsMod(name: user.name ?? "", address: user.address ?? "")
        keywords.append((user.email?.lowercased())!)
        keywords.append(emails[0].lowercased())
        
        let userProfile = ["name": user.name as Any,
                           "avatar": user.avatar as Any,
                           "phone": user.phone as Any,
                           "birthday": user.birthday as Any,
                           "address": user.address as Any,
                           "keywords": keywords] as [String : Any]
        
        db.collection("user_profile").document(userID).updateData(userProfile) { err in
            var result = true
            if let err = err {
                result = false
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
    }
    
    func search(searchText: String, completion: @escaping ([UserResponse]?) -> Void){
        var result = [UserResponse]()
        let searchConvert = String.convertVietNam1(text: searchText)
        
        let db = Firestore.firestore()
        let docRef = db.collection("user_profile").whereField("keywords", arrayContains: searchConvert.lowercased())
        
        docRef.getDocuments { (document, error) in
            if let document = document {
                
                for doc in document.documents {
                    let jsonData = try? JSONSerialization.data(withJSONObject: doc.data() as Any)
                    do {
                        let user = try JSONDecoder().decode(UserResponse.self, from: jsonData!)
                        user.id = doc.documentID
                        result.append(user)
                        
                    } catch let jsonError {
                        print("Error serializing json:", jsonError)
                    }
                }
                
                DispatchQueue.main.async {
                    completion(result)
                }
                
            } else {
                
                DispatchQueue.main.async {
                    completion(result)
                }
                print("User have no profile")
            }
        }
        
    }
    
    func getNearByUser(searchText: String, completion: @escaping ([UserResponse]?) -> Void){
        var result = [UserResponse]()
        
        let db = Firestore.firestore()
        let docRef = db.collection("user_profile").whereField("keywords", arrayContains: searchText.lowercased())
        
        docRef.getDocuments { (document, error) in
            if let document = document {
                
                for doc in document.documents {
                    let jsonData = try? JSONSerialization.data(withJSONObject: doc.data() as Any)
                    do {
                        let user = try JSONDecoder().decode(UserResponse.self, from: jsonData!)
                        user.id = doc.documentID
                        result.append(user)
                        
                    } catch let jsonError {
                        print("Error serializing json:", jsonError)
                    }
                }
                
                DispatchQueue.main.async {
                    completion(result)
                }
                
            } else {
                
                DispatchQueue.main.async {
                    completion(result)
                }
                print("User have no profile")
            }
        }
        
    }
    
    func checkLogedIn(completion: @escaping (Bool?) -> Void) {
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                // user is signed in
                // go to feature controller
                DispatchQueue.main.async {
                    completion(true)
                }
            } else {
                // user is not signed in
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
        
    }
    
    func updateAvatar(avatar: String) {
        let userID = Auth.auth().currentUser?.uid
        
        let db = Firestore.firestore()
        
        let userProfile = ["avatar": avatar as Any] as [String : Any]
        
        db.collection("user_profile").document(userID ?? "").updateData(userProfile) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}
