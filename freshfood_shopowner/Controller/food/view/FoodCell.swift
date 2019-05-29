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
    @IBOutlet weak var status: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func updateView(item: ShopItemResponse) {
        let price = (item.price?.formatPrice() ?? "") + "/\(item.unit!)"
        
        showImage(id: item.id ?? "", avatar: item.avatar ?? "")
        nameTxt.text = item.name
        priceTxt.text = price
        viewRating(rating: item.rating ?? 0.0, cmt: item.comment_number!)
        viewStatus(st: item.status ?? 0)
    }
    
    func viewStatus(st: Int) {
        if st == 0 {
            status.text = NSLocalizedString("Waiting", comment: "")
            status.textColor = UIColor.lightGray
        } else if st == 1 {
            status.text = NSLocalizedString("Selling", comment: "")
            status.textColor = .green
        } else {
            status.text = NSLocalizedString("Stoped", comment: "")
            status.textColor = .red
        }
    }
    
    func viewRating(rating: Double, cmt: Int) {
        if rating == 0.0 {
            ratingTxt.text = NSLocalizedString("No comment yet", comment: "")
            ratingTxt.textColor = .gray
        } else {
            ratingTxt.text = String(format: "%0.2f", rating) + " (\(cmt))"
            
            if rating < 2.5 {
                ratingTxt.textColor = .red
            } else if rating >= 4 {
                ratingTxt.textColor =  APP_COLOR
            } else if rating <= 5  {
                ratingTxt.textColor = .orange
            }
        }
        
    }
    
    func showImage(id: String, avatar: String)  {
        let folderPath = ReferenceImage.shopItem.rawValue + "/\(id)/\(avatar)"
        self.avatar.displayImage(folderPath: folderPath)
    }

}
