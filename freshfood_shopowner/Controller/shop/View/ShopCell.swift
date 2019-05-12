//
//  ShopCell.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/10/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import FirebaseStorage

class ShopCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopAddress: UILabel!
    @IBOutlet weak var infor: UILabel!
    
    
    func updateView(shop: ShopResponse) {
        
        let imageStorageRef = Storage.storage().reference(forURL: shop.avatar!)
        imageStorageRef.downloadURL(completion: { (url, error) in
            do {
                let data = try Data(contentsOf: url!)
                self.shopImage.image = UIImage(data: data as Data)
            } catch let error {
                print("Error with load image: \(error)")
            }
        })
            
        shopName.text = shop.name!
        shopAddress.text = shop.address
        if shop.status == 0 {
            infor.text = "Waiting"
            infor.textColor = UIColor.lightGray
        } else if shop.status == 1 {
            infor.text = "Selling"
        } else {
            infor.text = "Stoped"
            infor.textColor = .red
        }
    }

}
