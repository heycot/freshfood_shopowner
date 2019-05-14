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
    
    func updateView(cmt: CommentResponse, user: UserResponse?, item: ShopItemResponse?) {
        cmtTitle.text = cmt.title
        cmtContent.text = cmt.content
        
        if user != nil {
            guard let user = user else { return }
            foodName.text = user.name
            showUserAvatar(id: user.id ?? "", avatar: user.avatar ?? "")
        }
        
        if item != nil {
            guard let item = item else { return }
            foodName.text = item.name
            showFoodAvatar(id: item.id ?? "" , avatar: item.avatar ?? "")
        }
    }
    
    func showUserAvatar(id: String, avatar: String) {
        let folderPath = "/images/\(ReferenceImage.user.rawValue)/\(id)/\(avatar)"
        ImageServices.instance.downloadImages(folderPath: folderPath, success: { (data) in
            self.cmtImage.image = data
        }) { (error) in
            print("something wrong with url imgae")
        }
    }
    
    func showFoodAvatar(id: String, avatar: String) {
        let folderPath = "/images/\(ReferenceImage.shopItem.rawValue)/\(id)/\(avatar)"
        ImageServices.instance.downloadImages(folderPath: folderPath, success: { (data) in
            self.cmtImage.image = data
        }) { (error) in
            print("something wrong with url imgae")
        }
    }
    
    func viewRating(rating: Double) {
        if rating == 0.0 {
            cmtRating.text = "No comment yet"
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
