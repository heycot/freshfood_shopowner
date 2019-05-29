//
//  CustomUIImageView.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/25/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseUI

let imageCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingUrlString(urlString: String) {
        
        imageUrlString = urlString
        
        guard let url = URL(string: urlString) else { return }
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, respones, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            
            DispatchQueue.main.async {
                guard let data = data else { return }
                guard let imageToCache = UIImage(data: data) else { return }
                
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                
                imageCache.setObject(imageToCache, forKey: urlString as NSString)
            }
            
        }).resume()
    }
    
    
    func loadImageFromFirebase(folder: String) {
        
        imageUrlString = folder
        
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: folder as NSString) {
            self.image = imageFromCache
            return
        }
        
        ImageServices.instance.downloadImages(folderPath: folder, success: { (data) in
                        
            self.image = data
            imageCache.setObject(data, forKey: folder as NSString)
        }) { (err) in
            print("something wrong with image folder")
        }
    }
    
    func displayImage(folderPath: String) {
        let storage = Storage.storage()
        let storageRef = storage.reference(withPath: "images")
        
        // Reference to an image file in Firebase Storage
        let reference = storageRef.child(folderPath)
        
        
        // Load the image using SDWebImage
        self.sd_setImage(with: reference)
        
    }
    
}
