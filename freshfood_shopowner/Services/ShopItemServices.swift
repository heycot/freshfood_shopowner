
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
                print(document.documents)
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
    
}
