//
//  ImageServices.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/12/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class ImageServices {
     static let instance =  ImageServices()
    
    func uploadMedia(image: UIImage, fileName: String, completion: @escaping (_ url: String?) -> Void) {
        // Points to the root reference
        let storageRef = Storage.storage().reference()
        
        let data = image.pngData()
        
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child("images/" + fileName)
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putData(data!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                
                return
            }
            // Metadata contains file metadata such as size, content-type.
//            let size = metadata.size
            // You can also access to download URL after upload.
            riversRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                
                DispatchQueue.main.async {
                    completion(downloadURL.absoluteString)
                }
                
            }
        }

    }
    
}
