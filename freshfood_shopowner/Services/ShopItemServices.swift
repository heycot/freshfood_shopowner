
//
//  ShopItemServices.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/11/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

import Firebase

class ShopItemService {
    static let instance = ShopItemService()
    
    
    func getListShopItem( shopID: String,  completion: @escaping ([ShopItemResponse]?) -> Void) {
        
        let db = Firestore.firestore()
        let docRef = db.collection("shop_item").whereField("shop_id", isEqualTo: shopID)
        
        docRef.getDocuments(completion: { (document, error) in
            if let document = document {
                var shopItemList = [ShopItemResponse]()
                
                for shopItemDoct in document.documents{
                    let jsonData = try? JSONSerialization.data(withJSONObject: shopItemDoct.data() as Any)
                    
                    do {
                        var shopItem = try JSONDecoder().decode(ShopItemResponse.self, from: jsonData!)
                        shopItem.id = shopItemDoct.documentID
                        shopItemList.append(shopItem)
                    }
                    catch let jsonError {
                        print("Error serializing json:", jsonError)
                    }
                }
                DispatchQueue.main.async {
                    completion(shopItemList)
                }
                
            } else {
                print("User have no profile")
            }
        })
    }
    
    func addOne( item: ShopItemResponse,  completion: @escaping (Bool?) -> Void) {
        let date = Date().timeIntervalSince1970
        var result = true
        
        let item = ["name": item.name as Any,
                    "avatar": item.avatar ?? "logo" as Any,
                    "comment_number": 0,
                    "favorites_number": 0,
                    "create_date": date,
                    "rating": 0.0,
                    "shop_id": item.shop_id as Any,
                    "status": 1,
                    "unit": item.unit as Any,
                    "price": item.price as Any] as [String : Any]
            
        let db = Firestore.firestore()
        db.collection("shop_item").document().setData(item) { err in
            if let err = err {
                result = false
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
            
            DispatchQueue.main.async {
                completion(true)
            }
        }
        
    }
    
    func addNewList( items: [ShopItemResponse],  completion: @escaping (Bool?) -> Void) {
        let date = Date().timeIntervalSince1970
        var result = 0
        
        for item in items {
            let item = ["name": item.name as Any,
                        "avatar": item.avatar ?? "logo" as Any,
                        "comment_number": 0,
                        "favorites_number": 0,
                        "create_date": date,
                        "rating": 0.0,
                        "shop_id": item.shop_id as Any,
                        "status": 1,
                        "unit": item.unit as Any,
                        "price": item.price as Any] as [String : Any]
            
            let db = Firestore.firestore()
            db.collection("shop_item").document().setData(item) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    result += 1
                    print("Document successfully written!")
                }
                
            }
        }
        
        if result == items.count {
            DispatchQueue.main.async {
                completion(true)
            }
        } else {
            DispatchQueue.main.async {
                completion(false)
            }
        }
        
    }
    
    func editOne( item: ShopItemResponse,  completion: @escaping (Bool?) -> Void) {
        
        let db = Firestore.firestore()
        
        let values = ["name": item.name as Any,
                      "avatar": item.avatar ?? "logo" as Any,
                      "unit": item.unit as Any,
                      "price": item.price as Any] as [String : Any]
        
        db.collection("shop_item").document(item.id ?? "").updateData(values) { err in
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
