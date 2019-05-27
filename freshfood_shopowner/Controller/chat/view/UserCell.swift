//
//  UserCell.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/27/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var userAvatar: CustomImageView!
    @IBOutlet weak var user_name: UILabel!
    
    func updateView(user: UserResponse) {
        userAvatar.displayImage(folderPath: ReferenceImage.user.rawValue + "\(user.avatar ?? "")")
        user_name.text = user.name
        userAvatar.setButtomBorderRadious()
    }
}
