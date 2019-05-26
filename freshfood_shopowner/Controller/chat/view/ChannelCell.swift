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
    @IBOutlet weak var newMessage: UILabel!
    
    func updateView(channel: Channel) {
        name.text = channel.name
        name.setboldSystemFontOfSize(size: 18)
        channelImage.displayImage(folderPath: channel.folder_image)
        channelImage.setBorder(with: .white)
    }
}
