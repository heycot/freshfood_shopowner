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
    
    
    
}
