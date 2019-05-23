//
//  SearchService.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/23/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import Firebase


class SearchServices {
    
    public static let instance = SearchServices()
    
    func addOneByShop(shop: ShopResponse, completion: @escaping (Bool?) -> Void) {
        let db = Firestore.firestore()
        
        let keywords = String.gennerateKeywordsMod(name: shop.name ?? "", address: shop.address ?? "")
        
        let values = ["entity_id" : shop.id as Any,
                      "entity_name": shop.name as Any,
                      "address": shop.address as Any,
                      "is_shop": 1,
                      "avatar": shop.avatar as Any,
                      "keywords": keywords] as [String : Any]
        
        db.collection("search").addDocument(data: values) { (err) in
            if err != nil {
                DispatchQueue.main.async {
                    completion(false)
                }
            } else {
                DispatchQueue.main.async {
                    completion(true)
                }
            }
        }
    }
    
    func addOneByShopItem(shopItem: ShopItemResponse, completion: @escaping (Bool?) -> Void) {
        let db = Firestore.firestore()
        
        let keywords = String.gennerateKeywordsMod(name: shopItem.name ?? "", address: shopItem.address ?? "")
        
        let values = ["entity_id" : shopItem.id as Any,
                      "entity_name": shopItem.name as Any,
                      "address": shopItem.address as Any,
                      "is_shop": 0,
                      "avatar": shopItem.avatar as Any,
                      "keywords": keywords] as [String : Any]
        
        db.collection("search").addDocument(data: values) { (err) in
            if err != nil {
                DispatchQueue.main.async {
                    completion(false)
                }
            } else {
                DispatchQueue.main.async {
                    completion(true)
                }
            }
        }
    }
    
    func updateWhenEditShop(shop: ShopResponse, completion: @escaping (Bool?) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("search").whereField("entity_id", isEqualTo: shop.id ?? "")
                                            .whereField("is_shop", isEqualTo: 1)
        
        
        let keywords = String.gennerateKeywordsMod(name: shop.name ?? "", address: shop.address ?? "")
        
        let values = ["entity_name": shop.name as Any,
                      "address": shop.address as Any,
                      "avatar": shop.avatar as Any,
                      "keywords": keywords] as [String : Any]
        
        docRef.getDocuments(completion: { (document, error) in
            if let document = document {
                
                for doct in document.documents{
                    let searchID = doct.documentID
                    
                    db.collection("search").document(searchID).updateData(values, completion: { (err) in
                        if err != nil {
                            DispatchQueue.main.async {
                                completion(false)
                            }
                        } else {
                            DispatchQueue.main.async {
                                completion(true)
                            }
                        }
                    })
                }
                
                DispatchQueue.main.async {
                    completion(false)
                }
                
            } else {
                self.addOneByShop(shop: shop, completion: { (data) in
                    DispatchQueue.main.async {
                        completion(data)
                    }
                })
            }
        })
    }
    
    
    func updateWhenEditShopItem(shopItem: ShopItemResponse, completion: @escaping (Bool?) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("search").whereField("entity_id", isEqualTo: shopItem.id ?? "")
            .whereField("is_shop", isEqualTo: 0)
        
        
        let keywords = String.gennerateKeywordsMod(name: shopItem.name ?? "", address: shopItem.address ?? "")
        
        let values = ["entity_name": shopItem.name as Any,
                      "address": shopItem.address as Any,
                      "avatar": shopItem.avatar as Any,
                      "keywords": keywords] as [String : Any]
        
        docRef.getDocuments(completion: { (document, error) in
            if let document = document {
                
                for doct in document.documents{
                    let searchID = doct.documentID
                    
                    db.collection("search").document(searchID).updateData(values, completion: { (err) in
                        if err != nil {
                            DispatchQueue.main.async {
                                completion(false)
                            }
                        } else {
                            DispatchQueue.main.async {
                                completion(true)
                            }
                        }
                    })
                }
                
                DispatchQueue.main.async {
                    completion(false)
                }
                
            } else {
                self.addOneByShopItem(shopItem: shopItem, completion: { (data) in
                    DispatchQueue.main.async {
                        completion(data)
                    }
                })
            }
        })
    }
    
    
    
}
