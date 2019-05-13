//
//  CommentServices.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/13/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import Firebase

class  CommentServices {
    static let instance = CommentServices()
    
    func getAllCommentByFood(foodID: String,   completion: @escaping ([CommentResponse]?) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("comment").whereField("shop_item_id", isEqualTo: foodID)
    
        docRef.getDocuments(completion: { (document, error) in
            if let document = document {
            var cmts = [CommentResponse]()
    
            for cmtDoct in document.documents{
            let jsonData = try? JSONSerialization.data(withJSONObject: cmtDoct.data() as Any)
    
            do {
                var cmt = try JSONDecoder().decode(CommentResponse.self, from: jsonData!)
                cmt.id = cmtDoct.documentID
                cmts.append(cmt)
            }catch let jsonError {
                print("Error serializing json:", jsonError)
                }
            }
            DispatchQueue.main.async {
                completion(cmts)
             }
        
            } else {
                print("User have no profile")
            }
        })
    }
}
