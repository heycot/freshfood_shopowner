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
            getUserInfor(id: cmt.user_id ?? "")
        } else {
            getShopItemInfor(id: cmt.shop_item_id ?? "")
        }
    }
    
    func getUserInfor(id: String) {
        AuthServices.instance.getProfile(userID: id) { (data) in
            guard let data = data else { return }
            self.foodName.text = data.name
            self.showUserAvatar(avatar: data.avatar ?? "")
        }
    }
    
    func getShopItemInfor(id: String) {
        ShopItemService.instance.getOneById(shop_item_id: id) { (data) in
            guard let data = data else { return }
            self.foodName.text = data.name
            self.showFoodAvatar(id: data.id ?? "", avatar: data.avatar ?? "")
        }
    }
    
    func showUserAvatar( avatar: String) {
        let folderPath = ReferenceImage.user.rawValue + "/\(avatar)"
        ImageServices.instance.downloadImages(folderPath: folderPath, success: { (data) in
            self.cmtImage.image = data
            self.cmtImage.setRounded(color: .white)
        }) { (error) in
            print("something wrong with url imgae")
        }
    }
    
    func showFoodAvatar(id: String, avatar: String) {
        let folderPath = ReferenceImage.shopItem.rawValue + "/\(id)/\(avatar)"
        ImageServices.instance.downloadImages(folderPath: folderPath, success: { (data) in
            self.cmtImage.image = data
            self.cmtImage.setRounded(color: .white)
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
