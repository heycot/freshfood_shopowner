//
//  ChannelCell.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/26/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var channelImage: CustomImageView!
    
    func updateView(channel: Channel, userID: String, isShop: Bool) {
        
        if userID == channel.user_id_first {
            
            if isShop {
                name.text = channel.name_second + " - " + channel.name_first
            }
            
            name.setboldSystemFontOfSize(size: 18)
            channelImage.displayImage(folderPath: channel.image_second)
            channelImage.setBorder(with: .white)
        } else {
            if isShop {
                name.text = channel.name_first + " - " + channel.name_second
            }
            
            name.setboldSystemFontOfSize(size: 18)
            channelImage.displayImage(folderPath: channel.image_first)
            channelImage.setRounded(color: .white)
        }
    }
}
