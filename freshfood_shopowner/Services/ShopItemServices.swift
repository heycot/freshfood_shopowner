
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
        docRef.order(by: "rating", descending: true)
        
        
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
    
    
    func getOneById( shop_item_id: String,  completion: @escaping (ShopItemResponse?) -> Void) {
        
        let db = Firestore.firestore()
        let docRef = db.collection("shop_item").document(shop_item_id)
        
        docRef.getDocument(completion: { (document, error) in
            if let document = document, document.exists {
                let jsonData = try? JSONSerialization.data(withJSONObject: document.data() as Any)
                do {
                    var shopItem = try JSONDecoder().decode(ShopItemResponse.self, from: jsonData!)
                    shopItem.id = document.documentID
                    
                    DispatchQueue.main.async {
                        completion(shopItem)
                    }
                } catch let jsonError {
                    print("Error serializing json:", jsonError)
                }
                
            } else {
                print("User have no profile")
            }
        })
    }
    
    func addOne( item: ShopItemResponse,  completion: @escaping (String?) -> Void) {
        let date = Date().timeIntervalSince1970
        
        let item = ["name": item.name as Any,
                    "avatar": item.avatar ?? "logo" as Any,
                    "comment_number": 0,
                    "favorites_number": 0,
                    "create_date": date,
                    "rating": 0.0,
                    "shop_id": item.shop_id as Any,
                    "shop_name": item.shop_name as Any,
                    "status": 1,
                    "unit": item.unit as Any,
                    "item_id": item.item_id as Any,
                    "images": item.images as Any,
                    "price": item.price as Any,
                    "category_id": item.category_id as Any,
                    "time_open": item.time_open as Any,
                    "time_close": item.time_close as Any,
                    "address": item.address as Any,
                    "longitude": item.longitude as Any,
                    "latitude": item.latitude as Any,
                    "phone": item.phone as Any] as [String : Any]
            
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        
        // init first to get ID
        ref = db.collection("shop_item").document()
        
        ref?.setData(item, completion:{ (error) in
            DispatchQueue.main.async {
                completion(ref?.documentID)
            }
            
        })
        
        
        // When you use set() to create a document, you must specify an ID for the document to create.
//       db.collection("shop_item").document().setData(item) { err in
//            if let err = err {
//                print("Error writing document: \(err)")
//            } else {
//                print("Document successfully written!")
//            }
//
//            let id = ref?.documentID
//            DispatchQueue.main.async {
//                completion(id)
//            }
//        }
    }
    
    func editOne( item: ShopItemResponse,  completion: @escaping (Bool?) -> Void) {
        
        let db = Firestore.firestore()
        
        let values = ["name": item.name as Any,
                      "price": item.price as Any,
                      "unit": item.unit as Any,
                      "item_id": item.item_id as Any,
                      "images": item.images as Any,
                      "category_id": item.category_id as Any,
                      "time_open": item.time_open as Any,
                      "time_close": item.time_close as Any,
                      "address": item.address as Any,
                      "longitude": item.longitude as Any,
                      "latitude": item.latitude as Any,
                      "phone": item.phone as Any] as [String : Any]
        
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
    
    func changeStatus( id: String, status: Int,  completion: @escaping (Bool?) -> Void) {
        
        let db = Firestore.firestore()
        
        let values = ["status": status] as [String : Any]
        
        db.collection("shop_item").document(id).updateData(values) { err in
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
    
    
    func changeStatusByShop( shopId: String, status: Int) {
        
        let db = Firestore.firestore()
        
        let values = ["status": status] as [String : Any]
        
        let docRef = db.collection("shop_item").whereField("shop_id", isEqualTo: shopId)
        
        
        docRef.getDocuments(completion: { (document, error) in
            if let document = document {
                
                for shopItemDoct in document.documents{
                    
                    db.collection("shop_item").document(shopItemDoct.documentID).updateData(values) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                }
            } else {
                print("User have no profile")
            }
        })
        
        
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
                        "item_id": item.item_id as Any,
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
    
    
}
