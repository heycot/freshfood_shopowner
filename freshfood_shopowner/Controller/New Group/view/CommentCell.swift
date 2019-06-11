//
//  CommentCell.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/16/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var userImage: CustomImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var timeAgo: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var statusImg: UIImageView!
    
    
    func updateView(cmt: CommentResponse) {
        let folder = ReferenceImage.shopItem.rawValue + "\(cmt.shop_item_id ?? "")/\(cmt.shop_item_avatar ?? "")"
        userImage.displayImage(folderPath: folder)
        userImage.setBorder(with: .white)
        userName.text = "\(cmt.shop_item_name ?? "") - \(cmt.user_name ?? "")"
        title.text = cmt.title
        content.text = cmt.content
        viewRating(rt: cmt.rating ?? 3.0)
        let date = Date(timeIntervalSince1970: cmt.update_date ?? 0)
        timeAgo.text = date.timeAgoDisplay()
        if cmt.status != 1 {
            statusImg.image = #imageLiteral(resourceName: "error")
        }
    }
    
    func viewRating(rt: Double) {
        if rt == 0.0 {
            rating.text = NSLocalizedString("No comment yet", comment: "")
            rating.textColor = .gray
        } else {
            rating.text = String(format: "%0.2f", rt)
            
            if rt < 2.5 {
                rating.textColor = .red
            } else if rt >= 4 {
                rating.textColor = .green
            } else if rt <= 5  {
                rating.textColor = .orange
            }
        }
        
    }
}
