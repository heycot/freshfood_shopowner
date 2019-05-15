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
    
    func uploadMedia(image: UIImage, reference: String, completion: @escaping (_ url: String?) -> Void) {
        // Points to the root reference
        let storageRef = Storage.storage().reference()
        
        let data = image.jpeg(UIImage.JPEGQuality.lowest)
        
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child("images/" + reference)
        
        // Upload the file to the path "images/rivers.jpg"
        _ = riversRef.putData(data!, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
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
    
    func uploadListMedia(images: [UIImage], imageNames: [String], reference: String, completion: @escaping (_ url: Bool?) -> Void) {
        // Points to the root reference
        let storageRef = Storage.storage().reference()
        var result = 0
        
        for i in 0 ..< images.count {
            let data = images[i].jpeg(UIImage.JPEGQuality.lowest)
            
            // Create a reference to the file you want to upload
            let riversRef = storageRef.child("images/" + reference + "/\(imageNames[i])")
            
            // Upload the file to the path "images/rivers.jpg"
            _ = riversRef.putData(data!, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    return
                }
                result += 1
            }
        }
        
        if result == images.count {
            DispatchQueue.main.async {
                completion(true)
            }
            
        } else {
            DispatchQueue.main.async {
                completion(false)
            }
            
        }
        
    }
    
    
    func downloadImages( folderPath: String, success:@escaping (_ image:UIImage)->(),failure:@escaping (_ error:Error)->()){
        let reference = Storage.storage().reference(withPath: "\(folderPath)")
        reference.getData(maxSize: (1 * 1024 * 1024)) { (data, error) in
            if let _error = error{
                print(_error)
                failure(_error)
            } else {
                if let _data  = data {
                    let myImage:UIImage! = UIImage(data: _data)
                    success(myImage)
                }
            }
        }
    }
    
    
    
}
