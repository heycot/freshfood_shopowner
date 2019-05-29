//
//  UserCommentCell.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/12/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class UserCommentCell: UITableViewCell {
    @IBOutlet weak var cmtImage: CustomImageView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var cmtTitle: UILabel!
    @IBOutlet weak var cmtRating: UILabel!
    @IBOutlet weak var cmtContent: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateView(cmt: CommentResponse, isUser: Bool) {
        cmtTitle.text = cmt.title
        cmtContent.text = cmt.content
        viewRating(rating: cmt.rating ?? 3.0)
        
        if isUser {
            let folderPath = ReferenceImage.user.rawValue + "/\(cmt.user_avatar ?? "")"
            cmtImage.displayImage(folderPath: folderPath)
            foodName.text = cmt.user_name
        } else {
            let folderPath = ReferenceImage.shopItem.rawValue + "/\(cmt.shop_item_id ?? "")/\(cmt.shop_item_avatar ?? "")"
            cmtImage.displayImage(folderPath: folderPath)
            foodName.text = cmt.user_name
        }
    }
    
    
    func viewRating(rating: Double) {
        if rating == 0.0 {
            cmtRating.text = NSLocalizedString("No comment yet", comment: "")
            cmtRating.textColor = .gray
        } else {
            cmtRating.text = String(format: "%0.2f", rating)
            
            if rating < 2.5 {
                cmtRating.textColor = .red
            } else if rating >= 4 {
                cmtRating.textColor = .green
            } else if rating <= 5  {
                cmtRating.textColor = .orange
            }
        }
        
    }
}
