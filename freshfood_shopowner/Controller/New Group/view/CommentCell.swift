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
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var timeAgo: UILabel!
    @IBOutlet weak var rating: UILabel!
    
    
    func updateView(cmt: CommentResponse) {
        title.text = cmt.title
        content.text = cmt.content
        viewRating(rt: cmt.rating ?? 3.0)
        let date = Date(timeIntervalSince1970: cmt.update_date ?? 0)
        timeAgo.text = date.timeAgoDisplay()
    }
    
    func viewRating(rt: Double) {
        if rt == 0.0 {
            rating.text = "No comment yet"
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
