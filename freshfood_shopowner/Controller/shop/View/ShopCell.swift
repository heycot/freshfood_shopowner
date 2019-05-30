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
    
    @IBOutlet weak var shopImage: CustomImageView!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopAddress: UILabel!
    @IBOutlet weak var infor: UILabel!
    
    
    func updateView(shop: ShopResponse) {
        
        showImage(id: shop.id ?? "", avatar: shop.avatar ?? "" )
        shopName.text = shop.name!
        shopAddress.text = shop.address
        
        if shop.status == 0 {
            infor.text = NSLocalizedString("Waiting", comment: "")
            infor.textColor = UIColor.lightGray
        } else if shop.status == 1 {
            infor.text = NSLocalizedString("Selling", comment: "")
            infor.textColor = .green
        } else {
            infor.text = NSLocalizedString("Stoped", comment: "")
            infor.textColor = .red
        }
    }
    
    func showImage(id: String, avatar: String) {
        let folderPath = ReferenceImage.shop.rawValue + "/\(id)/\(avatar)"
        self.shopImage.displayImage(folderPath: folderPath)
    }

}
