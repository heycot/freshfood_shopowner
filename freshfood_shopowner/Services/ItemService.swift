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
                var tiems = [ItemResponse]()
                
                for itemDoct in document.documents{
                    let jsonData = try? JSONSerialization.data(withJSONObject: itemDoct.data() as Any)
                    
                    do {
                        var item = try JSONDecoder().decode(ItemResponse.self, from: jsonData!)
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
                print("User have no profile")
            }
        })
    }
}
