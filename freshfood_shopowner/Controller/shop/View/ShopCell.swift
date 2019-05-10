//
//  ShopCell.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/10/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

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
    @IBOutlet weak var viewInMapBtn: UIButton!
    
    
    func updateView(shop: ShopResponse) {
                
        shopImage.loadImageUsingUrlString(urlString: BASE_URL_IMAGE + shop.avatar!)
        shopName.text = shop.name!
        shopAddress.text = shop.address
        infor.text =  "Distance : " + (shop.getDistance(currlocation: AuthServices.instance.currentLocation))
    }

}
