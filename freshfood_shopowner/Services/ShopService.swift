
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
        let userID = Auth.auth().currentUser!.uid
        
        let db = Firestore.firestore()
        let docRef = db.collection("shop").whereField("user_id", isEqualTo: userID)
        
        docRef.getDocuments(completion: { (document, error) in
            if let document = document {
                print(document.documents)
                var shopList = [ShopResponse]()
                for shopDoct in document.documents{
                    let jsonData = try? JSONSerialization.data(withJSONObject: shopDoct.data() as Any)
                    do {
                        var shop = try JSONDecoder().decode(ShopResponse.self, from: jsonData!)
                        shop.id = shopDoct.documentID
                        shopList.append(shop)
                    }
                    catch let jsonError {
                        print("Error serializing json:", jsonError)
                    }
                }
                DispatchQueue.main.async {
                    completion(shopList)
                }
                
            } else {
                print("User have no profile")
            }
        })
    }
    
    func addNewShop(shop: ShopResponse, completion: @escaping (Bool?) -> Void) {
        let userID = Auth.auth().currentUser!.uid
        //Truy cập vào user_profile để lấy user profile với uid
        let db = Firestore.firestore()
        let shop = [
            "user_id": userID,
            "name": shop.name as Any,
            "rating": 0.0,
            "time_open": shop.time_open as Any,
            "time_close": shop.time_close as Any,
            "create_date": Date().timeIntervalSince1970,
            "status": 0,
            "phone": shop.phone as Any,
            "avatar": shop.avatar as Any,
            "keyword": shop.keyword as Any,
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
    
    func editShop(shop: ShopResponse, completion: @escaping (Bool?) -> Void) {
        
        let db = Firestore.firestore()
        
        let values = ["name": shop.name as Any,
                      "avatar": shop.avatar as Any,
                      "time_open": shop.time_open as Any,
                      "time_close": shop.time_close as Any,
                      "longitude": shop.longitude as Any,
                      "latitude": shop.latitude as Any,
                      "phone": shop.phone as Any,
                      "keyword": shop.keyword as Any,
                      "address": shop.address as Any ] as [String : Any]
        
        db.collection("shop").document(shop.id!).updateData(values) { err in
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
