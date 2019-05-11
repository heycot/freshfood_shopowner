//
//  FoodCell.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/11/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class FoodCell: UITableViewCell {
    
    @IBOutlet weak var avatar: CustomImageView!
    @IBOutlet weak var nameTxt: UILabel!
    @IBOutlet weak var priceTxt: UILabel!
    @IBOutlet weak var ratingTxt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func updateView(item: ShopItemResponse) {
        let priceFormat = (item.price?.formatPrice())!
//        let newStr = priceFormat.substring(from: 1) // Swift 3
        let price = "VND " + String(priceFormat) + "/\(item.unit!)"
        
        
        nameTxt.text = item.name
        priceTxt.text = price
        viewRating(rating: item.rating ?? 0.0, cmt: item.comment_number!)
    }
    
    func viewRating(rating: Double, cmt: Int) {
        if rating == 0.0 {
            ratingTxt.text = "No comment yet"
            ratingTxt.textColor = .gray
        } else {
            ratingTxt.text = String(format: "%0.2f", rating) + " (\(cmt))"
            
            if rating < 2.5 {
                ratingTxt.textColor = .red
            } else if rating >= 4 {
                ratingTxt.textColor = .green
            } else if rating <= 5  {
                ratingTxt.textColor = .orange
            }
        }
        
    }
    

}
