
//
//  ShopService.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/10/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import Firebase

class ShopService {
    static let instance = ShopService()
    
    func getListShop( completion: @escaping ([ShopResponse]?) -> Void) {
        var listitem = [ShopResponse]()
        
        let userID = Auth.auth().currentUser!.uid
        
        let db = Firestore.firestore()
        let docRef = db.collection("shop").whereField("user_id", isEqualTo: userID)
        
        docRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    
                    //                    print("\(document.documentID) => \(document.data())")
                    
                    let docRef = db.collection("shop").document(document.documentID)
                    
                    docRef.getDocument(completion: { (document, error) in
                        if let doc = document, doc.exists {
                            print(doc.data())
                            let jsonData = try? JSONSerialization.data(withJSONObject: doc.data() as Any)
                            do {
                                let shop = try JSONDecoder().decode(ShopResponse.self, from: jsonData!)
                                print(shop)
                                listitem.append(shop)
                                
                                DispatchQueue.main.async {
                                    completion(listitem)
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
        }
    }
    
    func addNewShop(shop: ShopResponse, completion: @escaping (Bool?) -> Void) {
        let userID = Auth.auth().currentUser!.uid
        let db = Firestore.firestore()
        
        let shop = [
            "user_id": userID,
            "name": shop.name as Any,
            "rating": 0.0,
            "time_open": shop.time_open as Any,
            "time_close": shop.time_close as Any,
            "create_date": Date(),
            "status": 0,
            "phone": "",
            "avatar": "",
            "sell": "",
            "longitude": shop.longitude as Any,
            "latitude": shop.latitude as Any,
            "address": shop.address as Any] as [String : Any]
        
        db.collection("shop").document().setData(shop) { err in
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
}
