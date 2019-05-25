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
        let name = ( shopItem.name ?? "") + " - " + (shopItem.shop_name ?? "")
        
        let values = ["entity_name": name as Any,
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
        let name = ( shopItem.name ?? "") + " - " + (shopItem.shop_name ?? "")
        
        let values = ["entity_name": name as Any,
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
    
    
    func search(searchText: String, completion: @escaping ([SearchResponse]?) -> Void) {
//        var results = [SearchResponse]()
        
        let db = Firestore.firestore()
        
        
        let docRef = db.collection("search")
        
        docRef.getDocuments(completion: { (document, error) in
            if let document = document {
                
                for searchDoct in document.documents{
                    let jsonData = try? JSONSerialization.data(withJSONObject: searchDoct.data() as Any)
                    
                    do {
                        let search = try JSONDecoder().decode(SearchResponse.self, from: jsonData!)
                        
                        if search.is_shop == 0 {
                            ShopItemService.instance.getOneById(shop_item_id: search.entity_id ?? "", completion: { (data) in
                                guard let data = data else { return }
                                
                                let name = search.entity_name! + " - " + data.shop_name!
                                let values = ["entity_name": name] as [String : Any]
                                
                                
                                db.collection("search").document(searchDoct.documentID).updateData(values, completion: { (err) in
                                    if err == nil {
                                        print("update success")
                                    }
                                })
                            })
                        }
                        
                        
                    }
                    catch let jsonError {
                        print("Error serializing json:", jsonError)
                    }
                }
                
                DispatchQueue.main.async {
                    completion(results)
                }
                
            } else {
                print("User have no profile")
            }
        })
        
    }
    
}
