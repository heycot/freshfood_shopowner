//
//  ChannelServices.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/26/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//


import Foundation
import Firebase

class ChannelServices {
    
    static let instance = ChannelServices()
    
    func checkChannel(channel: Channel, userID: String,  completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        var exists = false
        
        let docRef = db.collection("channels").whereField("users", arrayContains: userID as Any).whereField("name", isEqualTo: channel.name)
        
        docRef.getDocuments { (document, error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            
            if let document = document {
                
                for doc in document.documents {
                    exists = true
                    DispatchQueue.main.async {
                        completion(doc.documentID)
                    }
                    
                }
                
                if !exists {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    
    func addOne(channel: Channel,   completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        let values = ["folder_image": channel.folder_image as Any,
                      "users": channel.users as [String],
                      "name": channel.name as Any] as [String :  Any]
        
        let ref = db.collection("channels").document()
        
        ref.setData(values) { (error) in
            if let e = error {
                DispatchQueue.main.async {
                    completion(nil)
                }
                print("Error saving channel: \(e.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                completion(ref.documentID)
            }
        }
    }
    
    func getAllChannelByUser( completion: @escaping ([Channel]?) -> Void) {
        let userID = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        var channelList = [Channel]()
        
        let docRef = db.collection("channels").whereField("users", arrayContains: userID as Any)
        
        docRef.getDocuments { (document, error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            
            if let document = document {
                
                for doc in document.documents {
                    let jsonData = try? JSONSerialization.data(withJSONObject: doc.data() as Any)
                    
                    do {
                        var channel = try JSONDecoder().decode(Channel.self, from: jsonData!)
                        channel.id = doc.documentID
                        channelList.append(channel)
                    }
                    catch let jsonError {
                        print("Error serializing json:", jsonError)
                    }
                    
                }
                
                DispatchQueue.main.async {
                    completion(channelList)
                }
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
    
    
}
