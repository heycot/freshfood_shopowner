//
//  ItemService.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/15/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import Firebase


class ItemService {
    static let instance = ItemService()
    
    
    func getAllItem( completion: @escaping ([ItemResponse]?) -> Void) {
        
        let db = Firestore.firestore()
        let docRef = db.collection("item")
        
        docRef.getDocuments(completion: { (document, error) in
            if let document = document {
                var items = [ItemResponse]()
                
                for itemDoct in document.documents{
                    let jsonData = try? JSONSerialization.data(withJSONObject: itemDoct.data() as Any)
                    
                    do {
                        let item = try JSONDecoder().decode(ItemResponse.self, from: jsonData!)
                        item.id = itemDoct.documentID
                        items.append(item)
                    }
                    catch let jsonError {
                        print("Error serializing json:", jsonError)
                    }
                }
                DispatchQueue.main.async {
                    completion(items)
                }
                
            } else {
                DispatchQueue.main.async {
                    completion([])
                }
                print("User have no profile")
            }
        })
    }
    
    func getAllItemForEdit(category_id: String, completion: @escaping ([ItemResponse]?) -> Void) {
        
        let db = Firestore.firestore()
        let docRef = db.collection("item").whereField("category_id", isEqualTo: category_id)
        
        docRef.getDocuments(completion: { (document, error) in
            if let document = document {
                var items = [ItemResponse]()
                
                for itemDoct in document.documents{
                    let jsonData = try? JSONSerialization.data(withJSONObject: itemDoct.data() as Any)
                    
                    do {
                        let item = try JSONDecoder().decode(ItemResponse.self, from: jsonData!)
                        item.id = itemDoct.documentID
                        items.append(item)
                    }
                    catch let jsonError {
                        print("Error serializing json:", jsonError)
                    }
                }
                DispatchQueue.main.async {
                    completion(items)
                }
                
            } else {
                DispatchQueue.main.async {
                    completion([])
                }
                print("User have no profile")
            }
        })
    }
    
}
