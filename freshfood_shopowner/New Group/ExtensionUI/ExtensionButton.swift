//
//  ExtensionButton.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/26/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

extension UIButton {
    func setBorderRadous(color: UIColor) {
        self.backgroundColor = .clear
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
    }
    
    func boderRadiousWithoutCollor() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}

class CustomButton: UIButton {
    
    var UrlString: String?
    
    func viewImageUsingUrlString(urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if AuthServices.instance.isLoggedIn {
            request.addValue(AuthServices.instance.authToken, forHTTPHeaderField: "Authorization")
        } else {
            request.addValue("", forHTTPHeaderField: "Authorization")
        }
        
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, respones, error) in
            if error != nil {
                print(error ?? "")
                return
            }
            
            DispatchQueue.main.async {
                
                guard let data = data else {
                    self.imageView?.image = UIImage(named: "unlove")
                    return
                }
                
                do {
//                    let favorite = try JSONDecoder().decode(FavoritesResponse.self, from: data)
                    
//                    if favorite.id != nil, favorite.status! == 1 {
//                        self.imageView?.image = UIImage(named: "loved")
//                    } else {
//                        self.imageView?.image = UIImage(named: "unlove")
//                    }
                } catch let error {
                    print("error : \(error)")
                }
            }
        }).resume()
    }
}
