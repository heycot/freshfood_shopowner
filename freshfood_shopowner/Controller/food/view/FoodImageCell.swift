//
//  FoodImageCell.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/12/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class FoodImageCell: UICollectionViewCell {

    @IBOutlet weak var image: CustomImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateView(folder: String) {
        image.displayImage(folderPath: folder)
    }

}
